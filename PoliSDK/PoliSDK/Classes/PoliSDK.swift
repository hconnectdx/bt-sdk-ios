import CoreBluetooth
import Foundation
import HCBle

public class PoliSDK {
    // MARK: - Singleton

    public static let shared = PoliSDK()
    
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
            onReceiveSubscribtionData: onReceiveSubscribtionData
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
}
