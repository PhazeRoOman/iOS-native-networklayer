//
//  BaseNetworkService.swift
//  NetworkLayer
//
//  Created by Ali Jaber on 31/07/2022.
//

import Foundation
class HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        do {
            // TODO: Simplify the code of checking the iOS version
            if #available(iOS 15.0, *) {
                let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
                
                guard let response = response as? HTTPURLResponse else {
                    return .failure(.noResponse)
                }
                switch response.statusCode {
                case 200...204:
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        return .success(decodedResponse)
                    } catch _ {
                        return .failure(.decode)
                    }
                case 401:
                    return .failure(.unathorized)
                case 404:
                    return .failure(.notFound)
                default:
                    return .failure(.unknown)
                }
                
            } else {
                let (data, response) = try await URLSession.shared.data(from: request)
                guard let response = response as? HTTPURLResponse else {
                    return .failure(.noResponse)
                }
                switch response.statusCode {
                case 200...204:
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        return .success(decodedResponse)
                    } catch _ {
                        return .failure(.decode)
                    }
                case 401:
                    return .failure(.unathorized)
                case 404:
                    return .failure(.notFound)
                default:
                    print("response.statusCode = \(response.statusCode)")
                    return .failure(.defaultCase)
                }
            }

        } catch {
            return .failure(.unknown)
        }
    }
}
extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(from url: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}
