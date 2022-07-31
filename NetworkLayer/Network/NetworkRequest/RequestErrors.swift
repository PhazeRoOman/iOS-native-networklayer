//
//  RequestErrors.swift
//  NetworkLayer
//
//  Created by Ali Jaber on 31/07/2022.
//

import Foundation
enum RequestError: Error {
case unknown
case invalidURL
case noResponse
case decode
case unathorized
    var customMessage: String {
        //Add any message you want, this will be displayed to the user as an error message
        switch self {
        case .noResponse: return "No response"
        case .invalidURL: return "Invalid URL"
        case .decode: return "Error decoding data"
        case .unathorized: return "Unauthorized"
        default: return "Unknown error"
        }
    }
}
