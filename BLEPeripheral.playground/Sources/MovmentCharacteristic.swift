import CoreBluetooth

protocol CharacteristicController {
    var characteristic: CBMutableCharacteristic { get }
    func handleReadRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager)
    func handleWriteRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager)
    func handleSubscribeToCharacteristic(on peripheral: CBPeripheralManager)
}
class MovmentCharacteristic: CarsManagerDelegate, CharacteristicController {
    
    let characteristic: CBMutableCharacteristic
    let carsManager: CarsManager
    private var peripheral: CBPeripheralManager?
    
    init(characteristic: CBMutableCharacteristic = CharacteristicFactory.makeMovmentCharacteristic(),
         carsManager: CarsManager = .shared) {
        self.carsManager = carsManager
        self.characteristic = characteristic
        carsManager.delegate = self
    }
    
    func handleReadRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager) {
        guard let car = carsManager.cars.values.first else { return }
        request.value = car.moveDirection.bleData
        peripheral.respond(to: request, withResult: .success)
    }
    
    func handleSubscribeToCharacteristic(on peripheral: CBPeripheralManager) {
        self.peripheral = peripheral
    }
    
    func handleWriteRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager) {}
    
    func carsManager(_ carsManager: CarsManager, didUpdateCar carModel: RCCarModel) {
        print("Updating value: \(carModel), on: \(peripheral)")
        peripheral?.updateValue(carModel.moveDirection.bleData, for: characteristic, onSubscribedCentrals: nil)
    }
}

extension RCCarModel.MoveDirection {
    var bleData: Data {
        switch self {
        case .forward:
            return Data([0x01])
        case .backward:
            return Data([0x02])
        case .left:
            return Data([0x03])
        case .right:
            return Data([0x04])
        case .none:
            return Data([0x04])
        }
    }
}
