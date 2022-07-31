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
            default:
                return .failure(.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
