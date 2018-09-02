import CoreBluetooth

public class PeripheralController: NSObject, CBPeripheralManagerDelegate {
    
    enum Error: Swift.Error {
        case peripheralAlredyOn
        case peripheralAlreadyOff
    }
    
    private(set) var peripheral: CBPeripheralManager!
    let peripheralName: String
    private var serviceControllers: [ServiceController] = []
    
    public init(peripheralName: String) {
        self.peripheralName = peripheralName
        super.init()
    }
    
    public func registerServiceController(_ serviceController: ServiceController) {
        serviceControllers.append(serviceController)
    }
    
    public func turnOn() throws {
        if peripheral != nil { throw Error.peripheralAlredyOn }
        peripheral = CBPeripheralManager(delegate: self, queue: .main)
    }
    
    public func turnOff() throws {
        if peripheral == nil || peripheral.state != .poweredOn { throw Error.peripheralAlreadyOff }
        serviceControllers = []
        peripheral.stopAdvertising()
        peripheral = nil
    }
    
    private func startAdvertising() {
        print("Starting advertising")
        
        serviceControllers
            .map { $0.service }
            .forEach { peripheral.add($0) }
        
        let advertisementData: [String: Any] = [CBAdvertisementDataLocalNameKey: peripheralName,
                                                CBAdvertisementDataServiceUUIDsKey: serviceControllers.map({ $0.service.uuid })]
        peripheral.startAdvertising(advertisementData)
    }
    
    // MARK: - CBPeripheralManagerDelegate
    
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Peirpheral is on")
            startAdvertising()
        case .poweredOff:
            print("Peripheral \(peripheral.description) is off")
        case .resetting:
            print("Peripheral \(peripheral.description) is resetting")
        case .unauthorized:
            print("Peripheral \(peripheral.description) is unauthorized")
        case .unsupported:
            print("Peripheral \(peripheral.description) is unsupported")
        case .unknown:
            print("Peripheral \(peripheral.description) state unknown")
        }
    }
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("\(#function)")
        let serviceUUID = request.characteristic.service.uuid
        serviceControllers
            .first(where: { $0.service.uuid == serviceUUID })
            .map { $0.handleReadRequest(request, peripheral: peripheral) }
    }
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("\(#function)")
    }
    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        let serviceUUID = characteristic.service.uuid
        serviceControllers
            .first(where: { $0.service.uuid == serviceUUID })
            .map { $0.handleSubscribeToCharacteristic(characteristic: characteristic, on: peripheral) }
    }
}

