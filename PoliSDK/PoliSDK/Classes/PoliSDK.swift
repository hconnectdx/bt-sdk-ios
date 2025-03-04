import Foundation
import HCBle

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
public class PoliSDK {
    private static let TAG = "PoliBLE.swift"
    private static var expectedByte: UInt8 = 0x00
    private static var protocol2Count = 0
    private static var noMeaningData: UInt8 = 0x00 // Meaningless data for updates
    
    /// Start scanning for BLE devices
    public static func startScan(scanDevice: @escaping (CBPeripheral, [String: Any], NSNumber) -> Void) {
        HCBle.shared.scan { peripheral, advertisementData, RSSI in
            scanDevice(peripheral, advertisementData, RSSI)
        }
    }
    
    /// Stop scanning for BLE devices
    public static func stopScan() {
        // HCBle doesn't have a direct stopScan method, but we can implement one
        // For now, this is a placeholder
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
        HCBle.shared.connect(
            peripheral: device,
            onConnState: { connected, error in
                onConnState(connected, error)
            },
            onBondState: {
                onBondState()
            },
            onDiscoverServices: { services in
                onGattServiceState(services)
            },
            onSubscriptionState: { state in
                onSubscriptionState(state)
            },
            onReceiveSubscribtionData: { data in
                handleReceivedData(data, context: context, onReceive: onReceive)
            }
        )
    }
    
    /// Handle received data from BLE device
    private static func handleReceivedData(_ data: Data, context: Any?, onReceive: @escaping (ProtocolType, PoliResponse?) -> Void) {
        guard data.count >= 2 else { return }
        
        let protocolType = data[0]
        let dataOrder = data[1]
        
        switch protocolType {
        case 0x01:
            DispatchQueue.global(qos: .background).async {
                DailyServiceToApp.sendProtocol01ToApp(data, context, onReceive)
            }
            
        case 0x02:
            DailyProtocol02API.apply {
                DispatchQueue.global(qos: .background).async {
                    if DailyProtocol02API.prevByte != 0xfe, dataOrder == 0x00 {
                        onReceive(.PROTOCOL_2_START, nil)
                    }
                    DailyProtocol02API.prevByte = dataOrder
                    DailyProtocol02API.addByte(removeFrontTwoBytes(data, size: 2))
                    
                    if dataOrder == 0xff {
                        DailyServiceToApp.sendProtocol2ToApp(context, onReceive)
                    }
                }
            }
            
        case 0x03:
            DispatchQueue.global(qos: .background).async {
                DailyServiceToApp.sendProtocol03ToApp(data, onReceive)
            }
            
        case 0x04:
            DispatchQueue.global(qos: .background).async {
                do {
                    let response = SleepApiService().sendStartSleep()
                    let type: ProtocolType = response.retCd != "0" ? .PROTOCOL_4_SLEEP_START_ERROR : .PROTOCOL_4_SLEEP_START
                    onReceive(type, response)
                } catch {
                    print(error)
                }
            }
            
        case 0x05:
            DispatchQueue.global(qos: .background).async {
                do {
                    let response = SleepApiService().sendEndSleep()
                    let type: ProtocolType = response.retCd != "0" ? .PROTOCOL_5_SLEEP_END_ERROR : .PROTOCOL_5_SLEEP_END
                    onReceive(type, response)
                } catch {
                    print(error)
                }
            }
            
        case 0x06:
            SleepProtocol06API.addByte(removeFrontTwoBytes(data, size: 2))
            
            if dataOrder == 0xff {
                DispatchQueue.global(qos: .background).async {
                    do {
                        if let response = SleepApiService().sendProtocol06(context) {
                            onReceive(.PROTOCOL_6, response)
                        }
                    } catch {
                        print(error)
                        onReceive(.PROTOCOL_6_ERROR, nil)
                    }
                }
            } else {
                onReceive(.PROTOCOL_6, nil)
            }
            
        case 0x07:
            SleepProtocol07API.addByte(removeFrontTwoBytes(data, size: 2))
            
            if dataOrder == 0xff {
                DispatchQueue.global(qos: .background).async {
                    do {
                        if let response = SleepApiService().sendProtocol07(context) {
                            onReceive(.PROTOCOL_7, response)
                        }
                    } catch {
                        print(error)
                        onReceive(.PROTOCOL_7_ERROR, nil)
                    }
                }
            } else {
                onReceive(.PROTOCOL_7, nil)
            }
            
        case 0x08:
            SleepProtocol08API.addByte(removeFrontTwoBytes(data, size: 2))
            
            if dataOrder == 0xff {
                DispatchQueue.global(qos: .background).async {
                    do {
                        if let response = SleepApiService().sendProtocol08(context) {
                            onReceive(.PROTOCOL_8, response)
                        }
                    } catch {
                        print(error)
                        onReceive(.PROTOCOL_8_ERROR, nil)
                    }
                }
            } else {
                onReceive(.PROTOCOL_8, nil)
            }
            
        case 0x09:
            let hrSpO2 = HRSpO2Parser.asciiToHRSpO2(removeFrontTwoBytes(data, size: 1))
            
            DispatchQueue.global(qos: .background).async {
                do {
                    let response = SleepApiService().sendProtocol09(hrSpO2)
                    onReceive(.PROTOCOL_9_HR_SpO2, response)
                } catch {
                    print(error)
                    onReceive(.PROTOCOL_9_ERROR, nil)
                }
            }
            
        default:
            print("\(TAG) Unknown Protocol: \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")
        }
    }
    
    /// Remove front bytes from a Data object
    public static func removeFrontTwoBytes(_ byteArray: Data, size: Int) -> Data {
        if byteArray.count > size {
            return byteArray.subdata(in: size ..< byteArray.count)
        }
        return Data()
    }
    
    /// Disconnect from a device
    public static func disconnectDevice(deviceAddress: UUID) {
        HCBle.shared.disconnect(uuid: deviceAddress)
    }
    
    /// Get GATT service list
    public static func getGattServiceList(deviceAddress: UUID) -> [CBService]? {
        // HCBle doesn't have a direct getGattServiceList method
        // We would need to implement this by storing services when discovered
        return nil
    }
    
    /// Set target service UUID
    public static func setTargetServiceUUID(deviceAddress: UUID, uuid: String) {
        // Find the service with the given UUID and set it as the selected service
        if let peripheral = HCBle.shared.getPeripheral(uuid: deviceAddress),
           let services = peripheral.services
        {
            for service in services {
                if service.uuid.uuidString == uuid {
                    HCBle.shared.setService(uuid: deviceAddress, service: service)
                    break
                }
            }
        }
    }
    
    /// Set target characteristic UUID
    public static func setTargetCharacteristicUUID(deviceAddress: UUID, characteristicUUID: String) {
        // Find the characteristic with the given UUID and set it as the selected characteristic
        if let peripheral = HCBle.shared.getPeripheral(uuid: deviceAddress),
           let services = peripheral.services
        {
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid.uuidString == characteristicUUID {
                            HCBle.shared.setChar(uuid: deviceAddress, characteristic: characteristic)
                            break
                        }
                    }
                }
            }
        }
    }
    
    /// Read characteristic
    public static func readCharacteristic(deviceAddress: UUID) {
        HCBle.shared.readData(uuid: deviceAddress)
    }
    
    /// Write characteristic
    public static func writeCharacteristic(deviceAddress: UUID, data: Data) {
        // HCBle doesn't have a direct writeCharacteristic method for a specific device
        // We would need to implement this
        HCBle.shared.writeData(data)
    }
    
    /// Set characteristic notification
    public static func setCharacteristicNotification(
        deviceAddress: UUID,
        isEnable: Bool,
        isIndicate: Bool = false
    ) {
        if isEnable {
            HCBle.shared.enableNotifications(uuid: deviceAddress)
        } else {
            // Disable notifications - not directly supported in HCBle
        }
    }
    
    /// Get bonded devices
    public static func getBondedDevices() -> [CBPeripheral] {
        // iOS doesn't have a concept of "bonded" devices like Android
        // We would need to implement this by storing connected peripherals
        return []
    }
    
    /// Disconnect from a device
    public static func deconnect(address: UUID) {
        HCBle.shared.disconnect(uuid: address)
    }
    
    /// Disconnect from all devices
    public static func disconnectAll() {
        // HCBle doesn't have a direct disconnectAll method
        // We would need to implement this
    }
}

extension DailyProtocol02API {
    static func apply(_ block: () -> Void) {
        block()
    }
}
