import CoreBluetooth

public class MotionService: ServiceController {
    public let service: CBMutableService
    let movmentCharacteristic = MovmentCharacteristic()
    
    public init(service: CBMutableService = ServiceFactory.makeMotionService()) {
        self.service = service
        service.characteristics = [movmentCharacteristic.characteristic]
    }
    
    public func handleReadRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager) {
        guard request.characteristic.uuid == movmentCharacteristic.characteristic.uuid else { fatalError("Invalid request") }
        movmentCharacteristic.handleReadRequest(request, peripheral: peripheral)
        print("read value")
    }
    
    public func handleSubscribeToCharacteristic(characteristic: CBCharacteristic, on peripheral: CBPeripheralManager) {
        guard characteristic.uuid == movmentCharacteristic.characteristic.uuid else { fatalError("Invalid request") }
        movmentCharacteristic.handleSubscribeToCharacteristic(on: peripheral)
        print("\(#function) on \(peripheral)")
    }
    
    public func handleWriteRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager) {}
    
}
