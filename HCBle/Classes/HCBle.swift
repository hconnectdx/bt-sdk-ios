import CoreBluetooth

public class HCBle: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // Singleton instance
    public static let shared = HCBle()

    private var centralManager: CBCentralManager?
    private var scanCallback: ((CBPeripheral, [String: Any], NSNumber) -> Void)?
    private var connectCallback: ((CBPeripheral, Bool, Error?) -> Void)?
    private var discoverCallback: ((CBPeripheral, [String: Any], NSNumber) -> Void)?
    private var onConnState: ((Bool, Error?) -> Void)?
    private var onDiscoverServices: (([CBService]) -> Void)?

    // Private initializer to prevent additional instances
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    public func scan(callback: @escaping (CBPeripheral, [String: Any], NSNumber) -> Void) {
        scanCallback = callback
        guard let centralManager = centralManager else {
            print("Central Manager is not initialized")
            return
        }

        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning for peripherals...")
        } else {
            print("Bluetooth is not powered on")
        }
    }

    public func connect(
        peripheral: CBPeripheral,
        onConnState: ((Bool, Error?) -> Void)? = nil,
        onBondState: (() -> Void)? = nil,
        onDiscoverServices: (([CBService]) -> Void)? = nil,
        onReadCharacteristic: (() -> Void)? = nil,
        onWriteCharacteristic: (() -> Void)? = nil,
        onSubscriptionState: (() -> Void)? = nil,
        onReceive: (() -> Void)? = nil
    ) {
        self.onConnState = onConnState
        self.onDiscoverServices = onDiscoverServices

        guard let centralManager = centralManager else {
            print("Central Manager is not initialized")
            return
        }

        if centralManager.state == .poweredOn {
            print("Attempting to connect to \(peripheral.name ?? "Unknown Device")")
            centralManager.connect(peripheral, options: nil)
        } else {
            print("Bluetooth is not powered on")
        }
    }

    // CBCentralManagerDelegate methods
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
        case .poweredOff:
            print("Bluetooth is powered off")
        case .resetting:
            print("Bluetooth is resetting")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unsupported:
            print("Bluetooth is unsupported")
        case .unknown:
            print("Bluetooth state is unknown")
        @unknown default:
            print("A new state is available that is not handled")
        }
    }

    /* MARK: - Scan Callback */
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        scanCallback?(peripheral, advertisementData, RSSI)
    }

    /* MARK: - Connect State Callback */
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown Device")")
        onConnState?(true, nil)
        discoverServices(peripheral: peripheral)
    }

    /* MARK: - Discover Services */
    private func discoverServices(peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        guard let services = peripheral.services else { return }

        for service in services {
            print("Service UUID: \(service.uuid.uuidString)")
        }

        onDiscoverServices?(services)
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown Device")")
        onConnState?(false, error)
    }

    public func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        print("connectionEventDidOccur")
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral")
    }
}
