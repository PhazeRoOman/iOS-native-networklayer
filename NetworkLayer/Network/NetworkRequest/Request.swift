//
//  Request.swift
//  NetworkLayer
//
//  Created by Ali Jaber on 31/07/2022.
//

import Foundation
protocol Request {
    var method: HTTPMethod { get }
}

extension Request {
    var getMethod: HTTPMethod {
        .get
    }
}
