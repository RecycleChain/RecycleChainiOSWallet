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
    var currentBalance: UserBalanceVO? { get }
    
    func signup(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError>
    func signin(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError>
    func loadBalance() -> ApiTask<UserBalanceVO, UserModelError>
    func logout()
}

class WalletModelImpl: WalletModel {
    
    private var authService: AuthService
    private var walletService: WalletService
    
    init (authService: AuthService, walletService: WalletService) {
        self.authService = authService
        self.walletService = walletService
        self.currentUser = UserDefautsPackager().unpack(key: "currentUser")
    }
    
    private(set) var currentUser: UserVO? {
        didSet {
            UserDefautsPackager().pack(object: currentUser, key: "currentUser")
            self.walletService.token = currentUser?.token
            self.authService.token = currentUser?.token
        }
    }
    
    private(set) var currentBalance: UserBalanceVO? {
        didSet {
            UserDefautsPackager().pack(object: currentBalance, key: "currentBalance")
        }
    }
    
    func loadBalance() -> ApiTask<UserBalanceVO, UserModelError> {
        let task = ApiTask<UserBalanceVO, UserModelError>()
        task.dataRequest = walletService.balance(response: task.defaultHandler())
        task.addSuccess { balance in
            self.currentBalance = balance
        }.addFailure { error in
            self.logout()
        }
        return task
    }
    
    func signin(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError> {
        let task = ApiTask<UserVO, UserModelError>()
        task.dataRequest = authService.signInRequest(credentials: credentials, response: task.defaultHandler())
        task.addSuccess { user in
            self.currentUser = user
        }.addFailure { error in
            self.logout()
        }
        return task
    }
    
    func signup(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError> {
        let task = ApiTask<UserVO, UserModelError>()
        task.dataRequest = authService.signUpRequest(credentials: credentials, response: task.defaultHandler())
        return task
    }
    
    func logout() {
        self.currentUser = nil
        self.currentBalance = nil
    }
}

extension WalletModel {
    var isLoggedIn: Bool {
        return self.currentUser != nil
    }
}
