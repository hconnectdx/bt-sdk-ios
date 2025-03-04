import Foundation
import CoreBluetooth
import HCBle

extension HCBle {
    // Store connected peripherals for tracking
    private static var connectedPeripherals: [UUID: CBPeripheral] = [:]
    
    // Stop scanning for BLE devices
    public func stopScan() {
        guard let centralManager = centralManager else {
            print("Central Manager is not initialized")
            return
        }
        
        centralManager.stopScan()
        print("Scanning stopped")
    }
    
    // Disconnect all connected peripherals
    public func disconnectAll() {
        guard let centralManager = centralManager else {
            print("Central Manager is not initialized")
            return
        }
        
        for (uuid, peripheral) in HCBle.connectedPeripherals {
            centralManager.cancelPeripheralConnection(peripheral)
            print("Disconnected from \(peripheral.name ?? "Unknown Device") (\(uuid))")
        }
        
        HCBle.connectedPeripherals.removeAll()
    }
    
    // Track connected peripheral
    public func trackConnectedPeripheral(_ peripheral: CBPeripheral) {
        HCBle.connectedPeripherals[peripheral.identifier] = peripheral
    }
    
    // Remove tracked peripheral
    public func removeTrackedPeripheral(_ uuid: UUID) {
        HCBle.connectedPeripherals.removeValue(forKey: uuid)
    }
    
    // Get all connected peripherals
    public func getConnectedPeripherals() -> [CBPeripheral] {
        return Array(HCBle.connectedPeripherals.values)
    }
    
    // Write data to a specific peripheral
    public func writeData(_ data: Data, uuid: UUID) {
        guard let peripheralModel = peripherals.first(where: { $0.peripheral?.identifier == uuid }),
              let peripheral = peripheralModel.peripheral,
              let characteristic = peripheralModel.selChar else {
            print("Peripheral or characteristic is not set. Please ensure they are initialized.")
            return
        }
        
        // Write the data to the characteristic
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    // Disable notifications for a characteristic
    public func disableNotifications(uuid: UUID) {
        guard let peripheralModel = peripherals.first(where: { $0.peripheral?.identifier == uuid }),
              let peripheral = peripheralModel.peripheral,
              let characteristic = peripheralModel.selChar else {
            print("Peripheral or characteristic is not set. Please ensure they are initialized.")
            return
        }
        
        // Disable notifications for the characteristic
        peripheral.setNotifyValue(false, for: characteristic)
    }
    
    // Get services for a specific peripheral
    public func getServices(uuid: UUID) -> [CBService]? {
        guard let peripheralModel = peripherals.first(where: { $0.peripheral?.identifier == uuid }),
              let peripheral = peripheralModel.peripheral else {
            print("Peripheral not found.")
            return nil
        }
        
        return peripheral.services
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