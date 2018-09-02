import CoreBluetooth

public class ServiceFactory {
    public static func makeMotionService() -> CBMutableService {
        return CBMutableService(type: CBUUID(string: "0x2FA2"), primary: true)
    }
}
