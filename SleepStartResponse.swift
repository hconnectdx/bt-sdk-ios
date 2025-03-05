import Foundation

// MARK: - SleepResponse

public class SleepStartResponse: BaseResponse {
    public var data: Data?

    // required 초기화 메서드 구현
    public required init(retCd: String = "", retMsg: String = "", resDate: String = "") {
        super.init(retCd: retCd, retMsg: retMsg, resDate: resDate)
    }

    public init(data: Data? = nil) {
        self.data = data
        super.init()
    }

    public class Data {
        public let sessionId: String

        public init(sessionId: String) {
            self.sessionId = sessionId
        }
    }
    
    /// [String: Any] 딕셔너리를 SleepStartResponse 모델 객체로 변환하는 정적 메서드
    /// - Parameter dictionary: API 응답으로부터 받은 딕셔너리
    /// - Returns: 변환된 SleepStartResponse 객체
    /// - Throws: 필수 필드가 없거나 타입이 일치하지 않을 경우 오류 발생
    public static func convertToSleepStartResponse(from dictionary: [String: Any]) throws -> SleepStartResponse {
        // 기본 응답 필드 추출
        let retCd = dictionary["retCd"] as? String ?? ""
        let retMsg = dictionary["retMsg"] as? String ?? ""
        let resDate = dictionary["resDate"] as? String ?? ""
        
        // SleepStartResponse 객체 생성
        let response = SleepStartResponse(retCd: retCd, retMsg: retMsg, resDate: resDate)
        
        // data 필드 처리
        if let dataDict = dictionary["data"] as? [String: Any] {
            if let sessionId = dataDict["sessionId"] as? String {
                response.data = SleepStartResponse.Data(sessionId: sessionId)
            } else {
                // sessionId가 없거나 String 타입이 아닌 경우 오류 발생
                throw NSError(
                    domain: "ResponseParsingError",
                    code: 1001,
                    userInfo: [NSLocalizedDescriptionKey: "Missing or invalid sessionId in data"]
                )
            }
        }
        
        return response
    }
    
    /// [String: Any] 딕셔너리를 SleepStartResponse 모델 객체로 변환하는 정적 메서드 (try 없이 사용 가능)
    /// - Parameter dictionary: API 응답으로부터 받은 딕셔너리
    /// - Returns: 변환된 SleepStartResponse 객체 또는 nil (변환 실패 시)
    public static func fromDictionary(_ dictionary: [String: Any]) -> SleepStartResponse? {
        do {
            return try convertToSleepStartResponse(from: dictionary)
        } catch {
            print("SleepStartResponse 변환 실패: \(error.localizedDescription)")
            return nil
        }
    }
}