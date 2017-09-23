//
//  WalletModel.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit
import ObjectMapper

class UserDefautsPackager {
    
    func pack<T: BaseMappable>(object: T?, key: String) {
        if let object = object {
            let string = object.toJSONString()
            UserDefaults.standard.set(string, forKey: key)
        } else {
            UserDefaults.standard.set(nil, forKey: key)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func unpack<T: BaseMappable>(key: String) -> T? {
        guard let string = UserDefaults.standard.string(forKey: key) else {
            return nil
        }
        return Mapper<T>().map(JSONString: string)
    }
}

enum UserModelError: Error, InternalApiErrorConvertible {
    
    case generalError (reason: String)
    case invalidEmailPassword
    
    static func from(error: InternalApiError) -> UserModelError {
        switch error.reason {
        default:
            return .generalError(reason: error.reason)
        }
    }
    
    var reason: String {
        switch self {
        case .generalError(let reason):
            return reason
        case .invalidEmailPassword:
            return "Invalid email/password"
        }
    }
}

protocol WalletModel {
    var currentUser: UserVO? { get }
    func signup(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError>
    func signin(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError> 
}

class WalletModelImpl: WalletModel {
    
    private var authService: AuthService
    
    init (authService: AuthService) {
        self.authService = authService
        self.currentUser = UserDefautsPackager().unpack(key: "currentUser")
    }
    
    private(set) var currentUser: UserVO? {
        didSet {
            UserDefautsPackager().pack(object: currentUser, key: "currentUser")
        }
    }
    
    func signin(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError> {
        let task = ApiTask<UserVO, UserModelError>()
        task.dataRequest = authService.signInRequest(credentials: credentials, response: task.defaultHandler())
        task.addSuccess { user in
            self.currentUser = user
        }
        return task
    }
    
    func signup(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError> {
        let task = ApiTask<UserVO, UserModelError>()
        task.dataRequest = authService.signUpRequest(credentials: credentials, response: task.defaultHandler())
        task.addSuccess { user in
            self.currentUser = user
        }
        return task
    }
}
