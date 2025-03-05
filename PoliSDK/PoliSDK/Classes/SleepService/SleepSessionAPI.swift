// buildConfigField(
//    "String",
//    "CLIENT_ID", "\"3270e7da-55b1-4dd4-abb9-5c71295b849b\""
// )

// buildConfigField(
//    "String",
//    "CLIENT_SECRET",
//    "\"eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpbmZyYSI6IkhlYWx0aE9uLVN0YWdpbmciLCJjbGllbnQtaWQiOiIzMjcwZTdkYS01NWIxLTRkZDQtYWJiOS01YzcxMjk1Yjg0OWIifQ.u0rBK-2t3l4RZ113EzudZsKb0Us9PEtiPcFDBv--gYdJf9yZJQOpo41XqzbgSdDa6Z1VDrgZXiOkIZOTeeaEYA\""
// )

// 1. 요청 모델 정의
struct SleepStartRequest {
    let reqDate: String
    let userSno: Int

    init(userSno: Int) {
        self.reqDate = Date().currentTimeString()
        self.userSno = userSno
    }
}

class SleepSessionAPI {
    public static let shared = SleepSessionAPI()
    private init() {}

    func requestSleepStart(completion: @escaping (SleepStartResponse) -> Void) {
        // Encodable 요청 객체 생성
        let request: [String: Any] = [
            "reqDate": Date().currentTimeString(),
            "userSno": PoliAPI.shared.userSno
        ]

        // API 요청 수행
        PoliAPI.shared.post(
            path: "/sleep/start",
            body: request)
        { result in
            do {
                let response = try SleepStartResponse.convertToSleepStartResponse(from: result)
                PoliAPI.shared.sessionId = response.data?.sessionId ?? ""
                completion(response)
            } catch {
                print("[Error] Failed to parse SleepStartResponse\(error)")
            }
        }
    }

    func requestSleepStop(completion: @escaping (SleepStopResponse) -> Void) {
        if PoliAPI.shared.sessionId.isEmpty {
            completion(SleepStopResponse(retCd: "1", retMsg: "Session ID is empty", resDate: ""))
            return
        }

        // Encodable 요청 객체 생성
        let request: [String: Any] = [
            "reqDate": Date().currentTimeString(),
            "userSno": PoliAPI.shared.userSno,
            "sessionId": PoliAPI.shared.sessionId
        ]

        // API 요청 수행
        PoliAPI.shared.post(
            path: "/sleep/stop",
            body: request)
        { result in
            do {
                let response = try SleepStopResponse.convertToSleepStopResponse(from: result)
                completion(response)
            } catch {
                print("[Error] Failed to parse SleepStopResponse\(error)")
            }
        }
    }
}
