//
//  PoliAPI.swift
//  PoliSDK
//
//  Created by 곽민우 on 3/4/25.
//

import Foundation

public class PoliAPI {
    // MARK: - Singleton

    public static let shared = PoliAPI()

    // MARK: - Properties

    private var baseUrl: String = ""
    private var clientId: String = ""
    private var clientSecret: String = ""
    private var session: URLSession!
    
    public var userAge: Int = 0
    public var userSno: Int = 0
    public var sessionId: String = ""
    
    // MARK: - Initialization
    
    private init() {}
    
    public func initialize(baseUrl: String, clientId: String, clientSecret: String) {
        self.baseUrl = baseUrl
        self.clientId = clientId
        self.clientSecret = clientSecret
        
        // URLSession 설정
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 30.0
        
        session = URLSession(configuration: configuration)
    }
    
    /// GET 요청 수행
    /// - Parameters:
    ///   - path: API 경로
    ///   - parameters: URL 파라미터
    ///   - completion: 완료 콜백
    public func get<T: Decodable>(path: String, parameters: [String: String]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = buildURL(path: path, parameters: parameters) else {
            completion(.failure(PoliError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        addDefaultHeaders(to: &request)
        
        logRequest(request)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    /// POST 요청 수행
    /// - Parameters:
    ///   - path: API 경로
    ///   - body: 요청 바디
    ///   - completion: 완료 콜백
    public func post(
        path: String,
        body: [String: Any],
        completion: @escaping ([String: Any]) -> Void)
    {
        // URL 생성
        guard let url = URL(string: baseUrl + path) else {
            print("Invalid URL")
            return
        }
        
        // 요청 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addDefaultHeaders(to: &request)
        
        // 요청 바디 설정
        do {
            logRequest(request)
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error: \(error)")
            return
        }
        
        // 네트워크 요청 실행
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            self.logResponse(urlResponse!, data: data, error: error)
            if let error = error {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                // JSON 파싱
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Invalid JSON")
                    return
                }
                completion(json)
            } catch {
                return
            }
        }.resume()
    }
    
    // MARK: - Private Methods
    
    /// URL 생성
    private func buildURL(path: String, parameters: [String: String]? = nil) -> URL? {
        guard var components = URLComponents(string: baseUrl + path) else {
            return nil
        }
        
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url
    }
    
    /// 기본 헤더 추가
    private func addDefaultHeaders(to request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(clientId, forHTTPHeaderField: "ClientId")
        request.addValue(clientSecret, forHTTPHeaderField: "ClientSecret")
    }
    
    /// 요청 로깅
    private func logRequest(_ request: URLRequest) {
        print("\n[Request]")
        print("Method: \(request.httpMethod ?? "Unknown")")
        print("URL: \(request.url?.absoluteString ?? "Unknown")")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(prettyPrintJson(bodyString))")
        }
    }
    
    /// 응답 로깅
    private func logResponse(_ response: URLResponse, data: Data? = nil, error: Error? = nil) {
        print("\n[Response]")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Status Message: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
            print("URL: \(response.url?.absoluteString ?? "Unknown")")
            print("MIME Type: \(response.mimeType ?? "Unknown")")
            print("Expected Content Length: \(response.expectedContentLength)")
            
            if let headers = httpResponse.allHeaderFields as? [String: Any] {
                print("Headers: \(headers)")
            }
        } else {
            print("Status: \(response)")
        }
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print("Error Code: \(nsError.code)")
                print("Error Domain: \(nsError.domain)")
                if let failureReason = nsError.localizedFailureReason {
                    print("Failure Reason: \(failureReason)")
                }
            }
        }
        
        if let data = data {
            print("Data Size: \(data.count) bytes")
            
            if let bodyString = String(data: data, encoding: .utf8) {
                print("Body: \(prettyPrintJson(bodyString))")
            } else {
                print("Body: [Binary data]")
            }
        } else {
            print("Body: [No data]")
        }
    }
    
    /// 응답 로깅 및 처리
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            print("\n[Response Error]")
            print("Error: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(PoliError.invalidResponse))
            return
        }
        
        print("\n[Response]")
        print("Status: \(httpResponse.statusCode)")
        print("Headers: \(httpResponse.allHeaderFields)")
        
        guard let data = data else {
            completion(.failure(PoliError.noData))
            return
        }
        
        if let bodyString = String(data: data, encoding: .utf8) {
            print("Body: \(prettyPrintJson(bodyString))")
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            print("Decoding error: \(error)")
            completion(.failure(error))
        }
    }
    
    /// JSON 문자열을 보기 좋게 변환
    private func prettyPrintJson(_ jsonString: String) -> String {
        guard let data = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return jsonString
        }
        return prettyString
    }
}

// MARK: - Error Types

extension PoliAPI {
    enum PoliError: Error {
        case notInitialized
        case invalidURL
        case invalidResponse
        case noData
        
        var localizedDescription: String {
            switch self {
            case .notInitialized:
                return "PoliClient is not initialized"
            case .invalidURL:
                return "Invalid URL"
            case .invalidResponse:
                return "Invalid response"
            case .noData:
                return "No data received"
            }
        }
    }
}

public extension PoliAPI {
    func requestSleepStart(completion: @escaping (SleepStartResponse) -> Void) {
        SleepSessionAPI.shared.requestSleepStart(completion: { response in
            completion(response)
        })
    }
    
    func requestSleepStop(completion: @escaping (SleepStopResponse) -> Void) {
        SleepSessionAPI.shared.requestSleepStop(completion: { response in
            completion(response)
        })
    }
}
