
import Foundation
import CoreBluetooth

open class BluetoothScanner: NSObject, CBCentralManagerDelegate {
    
    public typealias DidDiscoverPeripheralClosure = (PeripheralRepresntable) -> Void
    var centralManager: CBCentralManager!
    private var onScannerReady: ((BluetoothScanner) -> Void)?
    private var onDiscover: DidDiscoverPeripheralClosure?
    
    public init(onScannerReady: @escaping (BluetoothScanner) -> Void) {
        self.onScannerReady = onScannerReady
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    open func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            onScannerReady?(self)
            onScannerReady = nil
        case .poweredOff:
            central.stopScan()
        case .unsupported: fatalError("Unsupported BLE module")
        default: break
        }
    }
    
    open func startScanning(_ onDiscover: @escaping DidDiscoverPeripheralClosure) {
        self.onDiscover = onDiscover
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // MARK: - CBCentralManagerDelegate
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        onDiscover?(peripheral.asPeripheral(advertisementData: advertisementData, rssi: RSSI.intValue))
    }
    
}
