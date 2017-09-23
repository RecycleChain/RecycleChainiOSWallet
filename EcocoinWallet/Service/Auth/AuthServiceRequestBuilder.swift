//
//  AuthServiceRequestBuilder.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Alamofire

protocol AuthServiceRequestBuilderProtocol: BaseServiceRequestBuilderProtocol, URLRequestConvertible {
    init (token: String?)
    func signin(email: String, password: String) -> AuthServiceRequestBuilderProtocol
    func signup(email: String, password: String, firstName: String, lastName: String) -> AuthServiceRequestBuilderProtocol
    func loadUser(userId: Int) -> AuthServiceRequestBuilderProtocol
}

class AuthServiceRequestBuilder: AuthServiceRequestBuilderProtocol {
    
    var token: String?
    var route: (method: HTTPMethod, path: String, parameters: [String : Any]?)!
    
    required init(token: String? = nil) {
        self.token = token
    }
    
    func loadUser(userId: Int) -> AuthServiceRequestBuilderProtocol {
        self.route = (.get, "users/api/users/\(userId)", [:])
        return self
    }
    
    func signin(email: String, password: String) -> AuthServiceRequestBuilderProtocol {
        self.route = (.post, "/api/auth/signin", ["email": email, "password": password])
        return self
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String) -> AuthServiceRequestBuilderProtocol {
        route = (.post, "/api/auth/signup",
                 ["email"                  : email,
                  "password"               : password,
                  "first_name"             : firstName,
                  "last_name"              : lastName])
        return self
    }
    
}

