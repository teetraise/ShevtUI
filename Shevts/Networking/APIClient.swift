//
//  APIClient.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(Int)
    case unauthorized
    case unknown
}

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "http://localhost:8080/api" // Замените на ваш URL сервера
    private var authToken: String?
    
    private init() {}
    
    func setToken(_ token: String) {
        self.authToken = token
    }
    
    func clearToken() {
        self.authToken = nil
    }
    
    func isAuthenticated() -> Bool {
        return authToken != nil
    }
    
    func request<T: Decodable>(endpoint: String, method: String = "GET", body: Data? = nil) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            print("❌ Invalid URL: \(baseURL)\(endpoint)")
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔑 Using token: \(token)")
        }
        
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print("📤 Request body: \(String(data: body, encoding: .utf8) ?? "nil")")
        }
        
        print("🌐 Sending \(method) request to: \(url.absoluteString)")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> APIError in
                print("❌ Network error: \(error.localizedDescription)")
                return APIError.requestFailed(error)
            }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Invalid response type")
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                print("📥 Response status: \(httpResponse.statusCode)")
                print("📥 Response body: \(String(data: data, encoding: .utf8) ?? "nil")")
                
                if httpResponse.statusCode == 401 {
                    print("🚫 Unauthorized")
                    return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    print("❌ Server error: \(httpResponse.statusCode)")
                    return Fail(error: APIError.serverError(httpResponse.statusCode)).eraseToAnyPublisher()
                }
                
                return Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { error -> APIError in
                        print("❌ Decoding error: \(error)")
                        return APIError.decodingFailed(error)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func uploadImage(imageData: Data) -> AnyPublisher<ImageResponse, APIError> {
        guard let url = URL(string: "\(baseURL)/images") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Создаем boundary для multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Формируем multipart/form-data
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { APIError.requestFailed($0) }
            .flatMap { data, response -> AnyPublisher<ImageResponse, APIError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                if httpResponse.statusCode == 401 {
                    return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    return Fail(error: APIError.serverError(httpResponse.statusCode)).eraseToAnyPublisher()
                }
                
                return Just(data)
                    .decode(type: ImageResponse.self, decoder: JSONDecoder())
                    .mapError { APIError.decodingFailed($0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
