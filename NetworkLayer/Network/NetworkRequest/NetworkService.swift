//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Ali Jaber on 31/07/2022.
//

import Foundation
protocol MyAppServiceProtocols {
    func loginAPIExample() async -> Result<UserModel, RequestError>
}

extension HTTPClient: MyAppServiceProtocols {
    func loginAPIExample() async -> Result<UserModel, RequestError> {
        return await sendRequest(endpoint: LoginEndpoint.login, responseModel: UserModel.self)
    }
    
    
}
