import Foundation

// MARK: - SleepResponse

public class SleepResponse: BaseResponse {
    public var data: Data?

    // required 초기화 메서드 구현
    override public required init(retCd: String = "", retMsg: String = "", resDate: String = "") {
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
}
