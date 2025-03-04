import Foundation
import CoreBluetooth

/// Enum representing the protocol types for communication
public enum ProtocolType {
    case PROTOCOL_1
    case PROTOCOL_2_START
    case PROTOCOL_2
    case PROTOCOL_3
    case PROTOCOL_4_SLEEP_START
    case PROTOCOL_4_SLEEP_START_ERROR
    case PROTOCOL_5_SLEEP_END
    case PROTOCOL_5_SLEEP_END_ERROR
    case PROTOCOL_6
    case PROTOCOL_6_ERROR
    case PROTOCOL_7
    case PROTOCOL_7_ERROR
    case PROTOCOL_8
    case PROTOCOL_8_ERROR
    case PROTOCOL_9_HR_SpO2
    case PROTOCOL_9_ERROR
}

/// Response protocol for Poli API responses
public protocol PoliResponse {
    var retCd: String { get }
}

/// Sleep response model
public struct SleepResponse: PoliResponse {
    public let retCd: String
    // Add other properties as needed
}

/// Sleep end response model
public struct SleepEndResponse: PoliResponse {
    public let retCd: String
    // Add other properties as needed
}

/// HR and SpO2 model
public struct HRSpO2 {
    public let hr: Int
    public let spO2: Int
}

/// HRSpO2 Parser utility
public class HRSpO2Parser {
    public static func asciiToHRSpO2(_ data: Data) -> HRSpO2 {
        // Implementation of parsing ASCII data to HR and SpO2
        // This is a placeholder - implement according to your protocol
        return HRSpO2(hr: 0, spO2: 0)
    }
}

/// Daily Protocol 02 API
public class DailyProtocol02API {
    static var prevByte: UInt8 = 0x00
    
    public static func addByte(_ data: Data) {
        // Implementation for adding bytes to the protocol
    }
    
    static func apply(_ block: () -> Void) {
        block()
    }
}

/// Sleep Protocol APIs
public class SleepProtocol06API {
    public static func addByte(_ data: Data) {
        // Implementation for adding bytes to the protocol
    }
}

public class SleepProtocol07API {
    public static func addByte(_ data: Data) {
        // Implementation for adding bytes to the protocol
    }
}

public class SleepProtocol08API {
    public static func addByte(_ data: Data) {
        // Implementation for adding bytes to the protocol
    }
}

/// Sleep API Service
public class SleepApiService {
    public func sendStartSleep() -> SleepResponse {
        // Implementation for sending start sleep request
        return SleepResponse(retCd: "0")
    }
    
    public func sendEndSleep() -> SleepEndResponse {
        // Implementation for sending end sleep request
        return SleepEndResponse(retCd: "0")
    }
    
    public func sendProtocol06(_ context: Any?) -> SleepResponse? {
        // Implementation for sending protocol 06
        return SleepResponse(retCd: "0")
    }
    
    public func sendProtocol07(_ context: Any?) -> SleepResponse? {
        // Implementation for sending protocol 07
        return SleepResponse(retCd: "0")
    }
    
    public func sendProtocol08(_ context: Any?) -> SleepResponse? {
        // Implementation for sending protocol 08
        return SleepResponse(retCd: "0")
    }
    
    public func sendProtocol09(_ hrSpO2: HRSpO2) -> SleepResponse {
        // Implementation for sending protocol 09
        return SleepResponse(retCd: "0")
    }
}

/// Daily Service To App
public class DailyServiceToApp {
    public static func sendProtocol01ToApp(_ byteArray: Data, _ context: Any?, _ onReceive: (ProtocolType, PoliResponse?) -> Void) {
        // Implementation for sending protocol 01 to app
    }
    
    public static func sendProtocol2ToApp(_ context: Any?, _ onReceive: (ProtocolType, PoliResponse?) -> Void) {
        // Implementation for sending protocol 2 to app
    }
    
    public static func sendProtocol03ToApp(_ byteArray: Data, _ onReceive: (ProtocolType, PoliResponse?) -> Void) {
        // Implementation for sending protocol 03 to app
    }
}

/// Main PoliBLE class for BLE operations
public class PoliBLE {
    private static let TAG = "PoliBLE.swift"
    private static var expectedByte: UInt8 = 0x00
    private static var protocol2Count = 0
    private static var noMeaningData: UInt8 = 0x00 // Meaningless data for updates
    
    // BLE Manager
    private static var centralManager: CBCentralManager?
    private static var peripherals: [UUID: CBPeripheral] = [:]
    private static var services: [UUID: [CBService]] = [:]
    private static var selectedServices: [UUID: CBService] = [:]
    private static var selectedCharacteristics: [UUID: CBCharacteristic] = [:]
    
    // Callbacks
    private static var onConnStateCallbacks: [UUID: (Bool, Error?) -> Void] = [:]
    private static var onGattServiceStateCallbacks: [UUID: ([CBService]) -> Void] = [:]
    private static var onBondStateCallbacks: [UUID: () -> Void] = [:]
    private static var onSubscriptionStateCallbacks: [UUID: (Bool) -> Void] = [:]
    private static var onReceiveCallbacks: [UUID: (ProtocolType, PoliResponse?) -> Void] = [:]
    
    /// Initialize the BLE module
    public static func initialize(context: Any) {
        centralManager = CBCentralManager(delegate: BLEManagerDelegate.shared, queue: nil)
    }
    
    /// Start scanning for BLE devices
    public static func startScan(scanDevice: @escaping (CBPeripheral, [String: Any], NSNumber) -> Void) {
        BLEManagerDelegate.shared.scanCallback = scanDevice
        
        guard let centralManager = centralManager, centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on")
            return
        }
        
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        print("Scanning for peripherals...")
    }
    
    /// Stop scanning for BLE devices
    public static func stopScan() {
        guard let centralManager = centralManager else {
            print("Central Manager is not initialized")
            return
        }
        
        centralManager.stopScan()
        print("Scanning stopped")
    }
    
    /// Connect to a BLE device
    public static func connectDevice(
        context: Any? = nil,
        device: CBPeripheral,
        onConnState: @escaping (Bool, Error?) -> Void,
        onGattServiceState: @escaping ([CBService]) -> Void,
        onBondState: @escaping () -> Void,
        onSubscriptionState: @escaping (Bool) -> Void,
        onReceive: @escaping (ProtocolType, PoliResponse?) -> Void
    ) {
        // Store callbacks
        onConnStateCallbacks[device.identifier] = onConnState
        onGattServiceStateCallbacks[device.identifier] = onGattServiceState
        onBondStateCallbacks[device.identifier] = onBondState
        onSubscriptionStateCallbacks[device.identifier] = onSubscriptionState
        onReceiveCallbacks[device.identifier] = onReceive
        
        // Set peripheral delegate
        device.delegate = BLEPeripheralDelegate.shared
        
        // Connect to peripheral
        guard let centralManager = centralManager, centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on")
            onConnState(false, NSError(domain: "Bluetooth not powered on", code: -1, userInfo: nil))
            return
        }
        
        peripherals[device.identifier] = device
        centralManager.connect(device, options: nil)
    }
    
    /// Handle received data from BLE device
    private static func handleReceivedData(_ data: Data, deviceId: UUID) {
        guard data.count >= 2 else { return }
        
        let protocolType = data[0]
        let dataOrder = data[1]
        let onReceive = onReceiveCallbacks[deviceId]
        
        switch protocolType {
        case 0x01:
            DispatchQueue.global(qos: .background).async {
                if let onReceive = onReceive {
                    DailyServiceToApp.sendProtocol01ToApp(data, nil, onReceive)
                }
            }
            
        case 0x02:
            DailyProtocol02API.apply {
                DispatchQueue.global(qos: .background).async {
                    if DailyProtocol02API.prevByte != 0xFE && dataOrder == 0x00 {
                        onReceive?(.PROTOCOL_2_START, nil)
                    }
                    DailyProtocol02API.prevByte = dataOrder
                    DailyProtocol02API.addByte(removeFrontTwoBytes(data, size: 2))
                    
                    if dataOrder == 0xFF {
                        if let onReceive = onReceive {
                            DailyServiceToApp.sendProtocol2ToApp(nil, onReceive)
                        }
                    }
                }
            }
            
        case 0x03:
            DispatchQueue.global(qos: .background).async {
                if let onReceive = onReceive {
                    DailyServiceToApp.sendProtocol03ToApp(data, onReceive)
                }
            }
            
        case 0x04:
            DispatchQueue.global(qos: .background).async {
                do {
                    let response = SleepApiService().sendStartSleep()
                    let type: ProtocolType = response.retCd != "0" ? .PROTOCOL_4_SLEEP_START_ERROR : .PROTOCOL_4_SLEEP_START
                    onReceive?(type, response)
                } catch {
                    print(error)
                }
            }
            
        case 0x05:
            DispatchQueue.global(qos: .background).async {
                do {
                    let response = SleepApiService().sendEndSleep()
                    let type: ProtocolType = response.retCd != "0" ? .PROTOCOL_5_SLEEP_END_ERROR : .PROTOCOL_5_SLEEP_END
                    onReceive?(type, response)
                } catch {
                    print(error)
                }
            }
            
        case 0x06:
            SleepProtocol06API.addByte(removeFrontTwoBytes(data, size: 2))
            
            if dataOrder == 0xFF {
                DispatchQueue.global(qos: .background).async {
                    do {
                        if let response = SleepApiService().sendProtocol06(nil) {
                            onReceive?(.PROTOCOL_6, response)
                        }
                    } catch {
                        print(error)
                        onReceive?(.PROTOCOL_6_ERROR, nil)
                    }
                }
            } else {
                onReceive?(.PROTOCOL_6, nil)
            }
            
        case 0x07:
            SleepProtocol07API.addByte(removeFrontTwoBytes(data, size: 2))
            
            if dataOrder == 0xFF {
                DispatchQueue.global(qos: .background).async {
                    do {
                        if let response = SleepApiService().sendProtocol07(nil) {
                            onReceive?(.PROTOCOL_7, response)
                        }
                    } catch {
                        print(error)
                        onReceive?(.PROTOCOL_7_ERROR, nil)
                    }
                }
            } else {
                onReceive?(.PROTOCOL_7, nil)
            }
            
        case 0x08:
            SleepProtocol08API.addByte(removeFrontTwoBytes(data, size: 2))
            
            if dataOrder == 0xFF {
                DispatchQueue.global(qos: .background).async {
                    do {
                        if let response = SleepApiService().sendProtocol08(nil) {
                            onReceive?(.PROTOCOL_8, response)
                        }
                    } catch {
                        print(error)
                        onReceive?(.PROTOCOL_8_ERROR, nil)
                    }
                }
            } else {
                onReceive?(.PROTOCOL_8, nil)
            }
            
        case 0x09:
            let hrSpO2 = HRSpO2Parser.asciiToHRSpO2(removeFrontTwoBytes(data, size: 1))
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let response = SleepApiService().sendProtocol09(hrSpO2)
                    onReceive?(.PROTOCOL_9_HR_SpO2, response)
                } catch {
                    print(error)
                    onReceive?(.PROTOCOL_9_ERROR, nil)
                }
            }
            
        default:
            print("\(TAG) Unknown Protocol: \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")
        }
    }
    
    /// Remove front bytes from a Data object
    public static func removeFrontTwoBytes(_ byteArray: Data, size: Int) -> Data {
        if byteArray.count > size {
            return byteArray.subdata(in: size..<byteArray.count)
        }
        return Data()
    }
    
    /// Disconnect from a device
    public static func disconnectDevice(deviceAddress: UUID) {
        guard let centralManager = centralManager, let peripheral = peripherals[deviceAddress] else {
            print("Device not found or Central Manager is not initialized")
            return
        }
        
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    /// Get GATT service list
    public static func getGattServiceList(deviceAddress: UUID) -> [CBService]? {
        return services[deviceAddress]
    }
    
    /// Set target service UUID
    public static func setTargetServiceUUID(deviceAddress: UUID, uuid: String) {
        guard let services = services[deviceAddress] else {
            print("No services found for device")
            return
        }
        
        for service in services {
            if service.uuid.uuidString == uuid {
                selectedServices[deviceAddress] = service
                break
            }
        }
    }
    
    /// Set target characteristic UUID
    public static func setTargetCharacteristicUUID(deviceAddress: UUID, characteristicUUID: String) {
        guard let service = selectedServices[deviceAddress] else {
            print("No service selected for device")
            return
        }
        
        guard let characteristics = service.characteristics else {
            print("No characteristics found for service")
            return
        }
        
        for characteristic in characteristics {
            if characteristic.uuid.uuidString == characteristicUUID {
                selectedCharacteristics[deviceAddress] = characteristic
                break
            }
        }
    }
    
    /// Read characteristic
    public static func readCharacteristic(deviceAddress: UUID) {
        guard let peripheral = peripherals[deviceAddress], let characteristic = selectedCharacteristics[deviceAddress] else {
            print("Peripheral or characteristic not found")
            return
        }
        
        peripheral.readValue(for: characteristic)
    }
    
    /// Write characteristic
    public static func writeCharacteristic(deviceAddress: UUID, data: Data) {
        guard let peripheral = peripherals[deviceAddress], let characteristic = selectedCharacteristics[deviceAddress] else {
            print("Peripheral or characteristic not found")
            return
        }
        
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    /// Set characteristic notification
    public static func setCharacteristicNotification(
        deviceAddress: UUID,
        isEnable: Bool,
        isIndicate: Bool = false
    ) {
        guard let peripheral = peripherals[deviceAddress], let characteristic = selectedCharacteristics[deviceAddress] else {
            print("Peripheral or characteristic not found")
            return
        }
        
        peripheral.setNotifyValue(isEnable, for: characteristic)
    }
    
    /// Get bonded devices
    public static func getBondedDevices() -> [CBPeripheral] {
        // iOS doesn't have a concept of "bonded" devices like Android
        return Array(peripherals.values)
    }
    
    /// Disconnect from a device
    public static func deconnect(address: UUID) {
        disconnectDevice(deviceAddress: address)
    }
    
    /// Disconnect from all devices
    public static func disconnectAll() {
        guard let centralManager = centralManager else {
            print("Central Manager is not initialized")
            return
        }
        
        for (_, peripheral) in peripherals {
            centralManager.cancelPeripheralConnection(peripheral)
        }
        
        peripherals.removeAll()
        services.removeAll()
        selectedServices.removeAll()
        selectedCharacteristics.removeAll()
        onConnStateCallbacks.removeAll()
        onGattServiceStateCallbacks.removeAll()
        onBondStateCallbacks.removeAll()
        onSubscriptionStateCallbacks.removeAll()
        onReceiveCallbacks.removeAll()
    }
}

// MARK: - BLE Manager Delegate
class BLEManagerDelegate: NSObject, CBCentralManagerDelegate {
    static let shared = BLEManagerDelegate()
    
    var scanCallback: ((CBPeripheral, [String: Any], NSNumber) -> Void)?
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        scanCallback?(peripheral, advertisementData, RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown Device")")
        
        // Notify connection state
        if let callback = PoliBLE.onConnStateCallbacks[peripheral.identifier] {
            callback(true, nil)
        }
        
        // Discover services
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown Device"): \(error?.localizedDescription ?? "Unknown error")")
        
        // Notify connection state
        if let callback = PoliBLE.onConnStateCallbacks[peripheral.identifier] {
            callback(false, error)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown Device"): \(error?.localizedDescription ?? "No error")")
        
        // Notify connection state
        if let callback = PoliBLE.onConnStateCallbacks[peripheral.identifier] {
            callback(false, error)
        }
        
        // Clean up
        PoliBLE.peripherals.removeValue(forKey: peripheral.identifier)
        PoliBLE.services.removeValue(forKey: peripheral.identifier)
        PoliBLE.selectedServices.removeValue(forKey: peripheral.identifier)
        PoliBLE.selectedCharacteristics.removeValue(forKey: peripheral.identifier)
        PoliBLE.onConnStateCallbacks.removeValue(forKey: peripheral.identifier)
        PoliBLE.onGattServiceStateCallbacks.removeValue(forKey: peripheral.identifier)
        PoliBLE.onBondStateCallbacks.removeValue(forKey: peripheral.identifier)
        PoliBLE.onSubscriptionStateCallbacks.removeValue(forKey: peripheral.identifier)
        PoliBLE.onReceiveCallbacks.removeValue(forKey: peripheral.identifier)
    }
}

// MARK: - BLE Peripheral Delegate
class BLEPeripheralDelegate: NSObject, CBPeripheralDelegate {
    static let shared = BLEPeripheralDelegate()
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        // Store services
        PoliBLE.services[peripheral.identifier] = services
        
        // Notify services discovered
        if let callback = PoliBLE.onGattServiceStateCallbacks[peripheral.identifier] {
            callback(services)
        }
        
        // Discover characteristics for each service
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid.uuidString)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error reading characteristic value: \(error.localizedDescription)")
            return
        }
        
        guard let data = characteristic.value else {
            print("Characteristic value is nil")
            return
        }
        
        // Process received data
        PoliBLE.handleReceivedData(data, deviceId: peripheral.identifier)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing characteristic value: \(error.localizedDescription)")
        } else {
            print("Successfully wrote value to characteristic: \(characteristic.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error changing notification state: \(error.localizedDescription)")
            PoliBLE.onSubscriptionStateCallbacks[peripheral.identifier]?(false)
            return
        }
        
        if characteristic.isNotifying {
            print("Notifications enabled for characteristic: \(characteristic.uuid)")
            PoliBLE.onSubscriptionStateCallbacks[peripheral.identifier]?(true)
        } else {
            print("Notifications disabled for characteristic: \(characteristic.uuid)")
            PoliBLE.onSubscriptionStateCallbacks[peripheral.identifier]?(false)
        }
    }
}

// Extension to Data for easier byte access
extension Data {
    // Access individual bytes using subscript
    subscript(index: Int) -> UInt8 {
        get {
            return self[self.startIndex.advanced(by: index)]
        }
    }
    
    // Convert to hex string for debugging
    var hexString: String {
        return self.map { String(format: "%02x", $0) }.joined(separator: " ")
    }
} 