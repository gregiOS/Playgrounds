import Foundation

public struct RCCarModel {
    public enum MoveDirection {
        case forward, backward, left, right, none
    }
    public let name: String
    public var moveDirection: MoveDirection
    
    public init(name: String) {
        self.name = name
        self.moveDirection = .none
    }
}
