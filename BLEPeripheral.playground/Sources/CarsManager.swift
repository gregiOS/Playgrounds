import Foundation

public protocol CarsManagerDelegate: class {
    func carsManager(_ carsManager: CarsManager, didUpdateCar carModel: RCCarModel)
}

public class CarsManager {
    
    public static let shared = CarsManager()
    
    public private(set) var cars: [String: RCCarModel] = [:] {
        didSet {
            cars.values.forEach({ delegate?.carsManager(self, didUpdateCar: $0) })
        }
    }
    public weak var delegate: CarsManagerDelegate?
    
    public func addCar(_ car: RCCarModel) {
        cars[car.name] = car
    }
    
    public func changeMoveDirection(carName: String, direction: RCCarModel.MoveDirection) {
        cars[carName]?.moveDirection = direction
    }
}
