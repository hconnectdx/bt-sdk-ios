import CoreBluetooth
import Foundation
import HCBle

public class PoliBLE {
    // MARK: - Singleton

    public static let shared = PoliBLE()
    
    /// 블루투스 스캔 시작
    /// - Parameter completion: 스캔 결과를 전달하는 콜백
    public func scan(completion: @escaping (CBPeripheral, [String: Any], NSNumber) -> Void) {
        HCBle.shared.scan(callback: completion)
    }
    
    /// 블루투스 스캔 중지
    public func stopScan() {
        // TODO:
    }
    
    /// 특정 기기에 연결
    /// - Parameters:
    ///   - peripheral: 연결할 기기
    ///   - completion: 연결 결과를 전달하는 콜백
    public func connect(
        peripheral: CBPeripheral,
        onConnState: ((Bool, Error?) -> Void)? = nil,
        onBondState: (() -> Void)? = nil,
        onDiscoverServices: (([CBService]) -> Void)? = nil,
        onDiscoverCharacteristics: ((CBService, [CBCharacteristic]) -> Void)? = nil,
        onReadCharacteristic: (() -> Void)? = nil,
        onWriteCharacteristic: (() -> Void)? = nil,
        onSubscriptionState: ((Bool) -> Void)? = nil,
        onReceiveSubscribtionData: ((Data) -> Void)? = nil
    ) {
        HCBle.shared.connect(
            peripheral: peripheral,
            onConnState: onConnState,
            onBondState: onBondState,
            onDiscoverServices: onDiscoverServices,
            onDiscoverCharacteristics: onDiscoverCharacteristics,
            onReadCharacteristic: onReadCharacteristic,
            onWriteCharacteristic: onWriteCharacteristic,
            onSubscriptionState: onSubscriptionState,
            onReceiveSubscribtionData: { _ in
//                self.handleReceivedData()
            }
        )
    }
    
    /// 연결된 기기 해제
    /// - Parameter peripheral: 해제할 기기
    public func disconnect(from uuid: UUID) {
        HCBle.shared.disconnect(uuid: uuid)
    }
    
    /// 모든 연결 해제
    public func disconnectAll() {
        // TODO:
    }
    
    public func readData(uuid: UUID) {
        HCBle.shared.readData(uuid: uuid)
    }
    
    /** TODO : 개별 디바이스에서 통신하도록 만들어야 함 */
    public func writeData(_ data: Data) {
        // TODO:
    }
    
    public func enableNotifications(uuid: UUID) {
        HCBle.shared.enableNotifications(uuid: uuid)
    }
    
    public func setService(uuid: UUID, service: CBService) {
        HCBle.shared.setService(uuid: uuid, service: service)
    }
    
    public func setChar(uuid: UUID, characteristic: CBCharacteristic) {
        HCBle.shared.setChar(uuid: uuid, characteristic: characteristic)
    }
    
    public func disconnect(uuid: UUID) {
        HCBle.shared.disconnect(uuid: uuid)
    }
    
    public func isConnected(uuid: UUID) -> Bool {
        return HCBle.shared.isConnected(uuid: uuid)
    }
    
    public func getPeripheral(uuid: UUID) -> CBPeripheral? {
        return HCBle.shared.getPeripheral(uuid: uuid)
    }

    /// 수신된 데이터 처리
    private func handleReceivedData(_ data: Data, from peripheral: UUID) {
        guard data.count >= 2 else { return }
        
        let protocolType = data[0]
        let dataOrder = data[1]
        
//        guard let onReceive = onReceiveCallbacks[peripheral] else { return }
        
        switch protocolType {
//        case 0x01:
//            DispatchQueue.global(qos: .background).async {
//                // DailyServiceToApp.sendProtocol01ToApp 구현 필요
//                self.sendProtocol01ToApp(data, onReceive: onReceive)
//            }
//
//        case 0x02:
//            DispatchQueue.global(qos: .background).async {
//                // 데이터 순서가 0x00 (처음) 이면 PROTOCOL_2_START 이벤트 발생
//                // 이전 데이터 순서가 0xFE면 맨 처음이 아님
//                if self.prevByte != 0xfe, dataOrder == 0x00 {
//                    onReceive(.PROTOCOL_2_START, nil)
//                }
//                self.prevByte = dataOrder
//                // DailyProtocol02API.addByte 구현 필요
//                self.addByteToProtocol02(self.removeFrontBytes(data, size: 2))
//
//                // 데이터 순서가 0xFF (마지막) 이면 PROTOCOL_2 전송 이벤트 발생
//                if dataOrder == 0xff {
//                    // DailyServiceToApp.sendProtocol2ToApp 구현 필요
//                    self.sendProtocol02ToApp(onReceive: onReceive)
//                }
//            }
//
//        case 0x03:
//            DispatchQueue.global(qos: .background).async {
//                // DailyServiceToApp.sendProtocol03ToApp 구현 필요
//                self.sendProtocol03ToApp(data, onReceive: onReceive)
//            }
            
        case 0x04:
            DispatchQueue.global(qos: .background).async {
//                SleepSessionAPI.shared.requestSleepStart()
                // SleepApiService().sendStartSleep() 구현 필요
//                self.sendStartSleep { response in
//                    let type: ProtocolType = response?.retCd != "0" ? .PROTOCOL_4_SLEEP_START_ERROR : .PROTOCOL_4_SLEEP_START
//                    onReceive(type, response)
//                }
            }
            
//        case 0x05:
//            DispatchQueue.global(qos: .background).async {
//                // SleepApiService().sendEndSleep() 구현 필요
//                self.sendEndSleep { response in
//                    let type: ProtocolType = response?.retCd != "0" ? .PROTOCOL_5_SLEEP_END_ERROR : .PROTOCOL_5_SLEEP_END
//                    onReceive(type, response)
//                }
//            }
//
//        case 0x06:
//            // SleepProtocol06API.addByte 구현 필요
//            self.addByteToProtocol06(self.removeFrontBytes(data, size: 2))
//
//            if dataOrder == 0xff {
//                DispatchQueue.global(qos: .background).async {
//                    // SleepApiService().sendProtocol06 구현 필요
//                    self.sendProtocol06 { response in
//                        if let response = response {
//                            onReceive(.PROTOCOL_6, response)
//                        } else {
//                            onReceive(.PROTOCOL_6_ERROR, nil)
//                        }
//                    }
//                }
//            } else {
//                onReceive(.PROTOCOL_6, nil)
//            }
//
//        case 0x07:
//            // SleepProtocol07API.addByte 구현 필요
//            self.addByteToProtocol07(self.removeFrontBytes(data, size: 2))
//
//            if dataOrder == 0xff {
//                DispatchQueue.global(qos: .background).async {
//                    // SleepApiService().sendProtocol07 구현 필요
//                    self.sendProtocol07 { response in
//                        if let response = response {
//                            onReceive(.PROTOCOL_7, response)
//                        } else {
//                            onReceive(.PROTOCOL_7_ERROR, nil)
//                        }
//                    }
//                }
//            } else {
//                onReceive(.PROTOCOL_7, nil)
//            }
//
//        case 0x08:
//            // SleepProtocol08API.addByte 구현 필요
//            self.addByteToProtocol08(self.removeFrontBytes(data, size: 2))
//
//            if dataOrder == 0xff {
//                DispatchQueue.global(qos: .background).async {
//                    // SleepApiService().sendProtocol08 구현 필요
//                    self.sendProtocol08 { response in
//                        if let response = response {
//                            onReceive(.PROTOCOL_8, response)
//                        } else {
//                            onReceive(.PROTOCOL_8_ERROR, nil)
//                        }
//                    }
//                }
//            } else {
//                onReceive(.PROTOCOL_8, nil)
//            }
//
//        case 0x09:
//            DispatchQueue.global(qos: .background).async {
//                // HRSpO2Parser.asciiToHRSpO2 구현 필요
//                let hrSpO2 = self.asciiToHRSpO2(self.removeFrontBytes(data, size: 1))
//
//                // SleepApiService().sendProtocol09 구현 필요
//                self.sendProtocol09(hrSpO2: hrSpO2) { response in
//                    if let response = response {
//                        onReceive(.PROTOCOL_9_HR_SpO2, response)
//                    } else {
//                        onReceive(.PROTOCOL_9_ERROR, nil)
//                    }
//                }
//            }
            
        default:
            break
//            print("\(PoliBLE.TAG) Unknown Protocol: \(data.hexString)")
        }
    }
}
