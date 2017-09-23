//
//  AuthService.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

protocol AuthService {
    
    var token:String? { set get }
    
    @discardableResult
    func signInRequest(credentials: LoginCredentialsVO, response: @escaping((DataResponse<UserVO>)->Void)) -> DataRequest
    @discardableResult
    func signUpRequest(credentials: LoginCredentialsVO, response: @escaping((DataResponse<UserVO>)->Void)) -> DataRequest
}

class AuthServiceImpl: BaseSessionService, AuthService {

    /** Private **/
 
    private func request<T: BaseMappable>(_ route: URLRequestConvertible, response:@escaping ((DataResponse<T>)->Void)) -> DataRequest {
        return manager.request(route).responseObject(completionHandler: response)
    }
    
    /** Public **/
    
    var token: String?
    
    func signInRequest(credentials: LoginCredentialsVO, response: @escaping((DataResponse<UserVO>)->Void)) -> DataRequest {
        let request = AuthServiceRequestBuilder(token: token).signin(email: credentials.email, password: credentials.password)
        return self.request(request, response: response)
    }
    
    func signUpRequest(credentials: LoginCredentialsVO, response: @escaping((DataResponse<UserVO>)->Void)) -> DataRequest {
        let request = AuthServiceRequestBuilder(token: token).signup(email: credentials.email, password: credentials.password,
                                                                     firstName: credentials.firstName ?? "", lastName: credentials.lastName ?? "")
        return self.request(request, response: response)
    }
}
