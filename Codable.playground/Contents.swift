//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

enum DisplayName {
    case firstName
    case secondName
    case fullName
}

extension DisplayName: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .firstName
        case 1:
            self = .secondName
        case 2:
            self = .fullName
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .firstName:
            try container.encode(0, forKey: .rawValue)
        case .secondName:
            try container.encode(1, forKey: .rawValue)
        case .fullName:
            try container.encode(2, forKey: .rawValue)
        }
    }
    
}

let displayName = DisplayName.firstName

let displayNameData = try? JSONEncoder().encode(displayName)

let displayNameJson = String(data: displayNameData!, encoding: .utf8)


// MARK: - LoginType

enum LoginType {
    case name(userName: String)
    case email(String)
}

extension LoginType: Codable {
    
    enum Key: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            let associtetedTypeValue = try container.decode(String.self, forKey: .associatedValue)
            self = .name(userName: associtetedTypeValue)
        case 1:
            let associtetedTypeValue = try container.decode(String.self, forKey: .associatedValue)
            self = .email(associtetedTypeValue)
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .name(let userName):
            try container.encode(0, forKey: .rawValue)
            try container.encode(userName, forKey: .associatedValue)
        case .email(let email):
            try container.encode(1, forKey: .rawValue)
            try container.encode(email, forKey: .associatedValue)
        }
    }
    
}

let loginType = LoginType.name(userName: "User")

let data = try? JSONEncoder().encode(loginType)

let stringData = String(data: data!, encoding: .utf8)

// MARK: - AuthenticationType

enum AuthenticationType {
    case password(String?)
    case twoFactorCode(String?)
}

extension AuthenticationType: Codable {
    
    enum Key: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            let password = try container.decodeIfPresent(String.self, forKey: .associatedValue)
            self = .password(password)
        case 1:
            let code = try container.decodeIfPresent(String.self, forKey: .associatedValue)
            self = .twoFactorCode(code)
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .password(let password):
            try container.encode(0, forKey: .rawValue)
            try container.encode(password, forKey: .associatedValue)
        case .twoFactorCode(let code):
            try container.encode(1, forKey: .rawValue)
            try container.encode(code, forKey: .associatedValue)
        }
    }
    
}

let authentication = AuthenticationType.password(nil)
let authenticationData = try? JSONEncoder().encode(authentication)
let authenticationString = String(data: authenticationData!, encoding: .utf8)



