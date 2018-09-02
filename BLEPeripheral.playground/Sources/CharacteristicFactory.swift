import CoreBluetooth

public class CharacteristicFactory {
    public static func makeMovmentCharacteristic() -> CBMutableCharacteristic {
        return CBMutableCharacteristic(type: CBUUID(string: "0x1a2b"), properties: [.read, .notify], value: nil, permissions: [.readable])
    }
}
