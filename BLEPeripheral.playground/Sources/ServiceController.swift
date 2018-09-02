import CoreBluetooth

public protocol ServiceController {
    var service: CBMutableService { get }
    func handleReadRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager)
    func handleWriteRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager)
    func handleSubscribeToCharacteristic(characteristic: CBCharacteristic, on peripheral: CBPeripheralManager)
}
