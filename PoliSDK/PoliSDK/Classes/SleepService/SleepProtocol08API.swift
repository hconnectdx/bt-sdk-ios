class SleepProtocol08API {
    public static let shared = SleepProtocol08API()
    private init() {}
    
    func requestSleepProtocol08(completion: @escaping (SleepResponse) -> Void) {
        // Encodable 요청 객체 생성
        let request: [String: Any] = [
            "reqDate": Date().currentTimeString(),
            "userSno": PoliAPI.shared.userSno,
            "sessionId": PoliAPI.shared.sessionId
        ]
        
        // API 요청 수행
        PoliAPI.shared.post(
            path: "/sleep/protocol8",
            body: request)
        { _ in
            do {
                //                let response = try SleepStartResponse.convertToSleepStartResponse(from: result)
                //                PoliAPI.shared.sessionId = response.data?.sessionId ?? ""
                //                completion(response)
            } catch {
                print("[Error] Failed to parse SleepProtocol06Response\(error)")
            }
        }
    }
}
