# PoliBLE

PoliBLE is a Swift wrapper for the HCBle library that provides Bluetooth Low Energy (BLE) functionality for the PoliSDK. This class is designed to work with specific BLE protocols for health monitoring devices.

## Features

- Scan for BLE devices
- Connect to BLE devices
- Send and receive data using specific protocols
- Handle sleep monitoring data
- Process heart rate and SpO2 data

## Usage

### Initialization

Initialize the PoliBLE module:

```swift
PoliBLE.init(context: self)
```

### Scanning for Devices

Start scanning for BLE devices:

```swift
PoliBLE.startScan { peripheral, advertisementData, RSSI in
    // Handle discovered device
    print("Found device: \(peripheral.name ?? "Unknown")")
}
```

Stop scanning:

```swift
PoliBLE.stopScan()
```

### Connecting to a Device

Connect to a BLE device:

```swift
PoliBLE.connectDevice(
    device: peripheral,
    onConnState: { connected, error in
        if connected {
            print("Connected to device")
        } else {
            print("Failed to connect: \(error?.localizedDescription ?? "Unknown error")")
        }
    },
    onGattServiceState: { services in
        print("Discovered \(services.count) services")
    },
    onBondState: {
        print("Bond state changed")
    },
    onSubscriptionState: { state in
        print("Subscription state: \(state)")
    },
    onReceive: { protocolType, response in
        // Handle received data based on protocol type
        switch protocolType {
        case .PROTOCOL_1:
            print("Received Protocol 1 data")
        case .PROTOCOL_2:
            print("Received Protocol 2 data")
        // Handle other protocol types
        default:
            print("Received unknown protocol data")
        }
    }
)
```

### Working with Services and Characteristics

Set target service UUID:

```swift
PoliBLE.setTargetServiceUUID(deviceAddress: peripheral.identifier, uuid: "YOUR_SERVICE_UUID")
```

Set target characteristic UUID:

```swift
PoliBLE.setTargetCharacteristicUUID(deviceAddress: peripheral.identifier, characteristicUUID: "YOUR_CHARACTERISTIC_UUID")
```

Read characteristic:

```swift
PoliBLE.readCharacteristic(deviceAddress: peripheral.identifier)
```

Write to characteristic:

```swift
let data = Data([0x01, 0x02, 0x03])
PoliBLE.writeCharacteristic(deviceAddress: peripheral.identifier, data: data)
```

Enable notifications:

```swift
PoliBLE.setCharacteristicNotification(deviceAddress: peripheral.identifier, isEnable: true)
```

### Disconnecting

Disconnect from a device:

```swift
PoliBLE.disconnectDevice(deviceAddress: peripheral.identifier)
```

Disconnect from all devices:

```swift
PoliBLE.disconnectAll()
```

## Protocol Types

The PoliBLE class supports various protocol types for communication:

- PROTOCOL_1: Daily data protocol 1
- PROTOCOL_2_START: Start of protocol 2 data
- PROTOCOL_2: Daily data protocol 2
- PROTOCOL_3: Daily data protocol 3
- PROTOCOL_4_SLEEP_START: Sleep start protocol
- PROTOCOL_5_SLEEP_END: Sleep end protocol
- PROTOCOL_6, PROTOCOL_7, PROTOCOL_8: Sleep data protocols
- PROTOCOL_9_HR_SpO2: Heart rate and SpO2 data protocol

## Notes

- This implementation is designed to match the functionality of the Android version of PoliBLE.
- Some methods are placeholders and may need to be implemented based on specific requirements.
- iOS handles BLE differently than Android, so some adaptations have been made to match the iOS CoreBluetooth framework.
