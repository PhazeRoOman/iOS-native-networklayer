//
//  LoginExampleEndpoint.swift
//  NetworkLayer
//
//  Created by Ali Jaber on 31/07/2022.
//

import Foundation
enum LoginEndpoint {
    case login
}

extension LoginEndpoint: Endpoint {
    var path: String {
        return "/urlPath"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var header: [String : String]? {
        return nil
    }
    
    var body: [String : Any]? {
        return ["username" : "myUsername", "password": ["myPassword"]]
    }
    
    
}
