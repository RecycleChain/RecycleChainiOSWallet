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
    
    func packArray<T: BaseMappable>(objects: [T]?, key: String) {
        if let objects = objects {
            let string = objects.toJSONString()
            UserDefaults.standard.set(string, forKey: key)
        } else {
            UserDefaults.standard.set(nil, forKey: key)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func unpackArray<T: BaseMappable>(key: String) -> [T]? {
        guard let string = UserDefaults.standard.string(forKey: key) else {
            return nil
        }
        return Mapper<T>().mapArray(JSONString: string)
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
    var transactions: [UserTransactionVO]? { get }
    var stock: StockVO? { get }
    
    func signup(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError>
    func signin(credentials: LoginCredentialsVO) -> ApiTask<UserVO, UserModelError>
    func logout()
    
    func loadBalance() -> ApiTask<UserBalanceVO, UserModelError>
    func loadTransactions() -> ApiTask<[UserTransactionVO], UserModelError>
    func loadStocks() -> ApiTask<[StockVO], UserModelError>
    
    func createStock(phone: String?, address: String?, details: String?) -> ApiTask<StockVO, UserModelError>
    func createTransaction(materials: [MaterialVO], receiverId: Int) -> ApiTask<TransactionVO, UserModelError>
}

class WalletModelImpl: WalletModel {
    
    private var authService: AuthService
    private var walletService: WalletService
    private var stockService: StockService
    
    init (authService: AuthService, walletService: WalletService, stockService: StockService) {
        self.authService = authService
        self.walletService = walletService
        self.stockService = stockService

        self.currentUser = UserDefautsPackager().unpack(key: "currentUser")
        self.currentBalance = UserDefautsPackager().unpack(key: "currentBalance")
        self.transactions = UserDefautsPackager().unpackArray(key: "transactions")
        self.stock = UserDefautsPackager().unpack(key: "stock")
 
        updateTokens()
        
        /*
        self.currentUser = UserVO(id: 0, firstName: "Kirill", lastName: "Kirikov", email: "olmer.k@gmail.com", token: "token")
        self.currentBalance = UserBalanceVO(balance: "0.0")
        self.transactions = [
            UserTransactionVO(id: 0, date: Date(), amount: 100.0, currency: "EC"),
            UserTransactionVO(id: 1, date: Date(), amount: -15.5, currency: "PC"),
            UserTransactionVO(id: 2, date: Date(), amount: 25.0, currency: "EC")
        ]
        self.stock = StockVO(id: 0)
         */
    }
    
    private func updateTokens() {
        self.walletService.token = currentUser?.token
        self.authService.token = currentUser?.token
        self.stockService.token = currentUser?.token
    }
    
    private(set) var currentUser: UserVO? {
        didSet {
            UserDefautsPackager().pack(object: currentUser, key: "currentUser")
            updateTokens()
        }
    }
    
    private(set) var currentBalance: UserBalanceVO? {
        didSet {
            UserDefautsPackager().pack(object: currentBalance, key: "currentBalance")
        }
    }
    
    private(set) var transactions: [UserTransactionVO]? {
        didSet {
            UserDefautsPackager().packArray(objects: transactions, key: "transactions")
        }
    }
    
    private(set) var stock: StockVO? {
        didSet {
            UserDefautsPackager().pack(object: stock, key: "stock")
        }
    }
    
    func loadTransactions() -> ApiTask<[UserTransactionVO], UserModelError> {
        let task = ApiTask<[UserTransactionVO], UserModelError>()
        task.dataRequest = walletService.transactions(response: task.defaultHandler())
        task.addSuccess {[weak self] transactions in
            self?.transactions = transactions
        }
        return task
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
    
    func loadStocks() -> ApiTask<[StockVO], UserModelError> {
        let task = ApiTask<[StockVO], UserModelError>()
        task.dataRequest = stockService.mystocks(response: task.defaultHandler())
        task.addSuccess {[weak self] stocks in
            self?.stock = stocks.first
        }.addFailure { error in
            print("Error loading my stocks: \(error)")
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
        self.transactions = nil
        self.stock = nil
        updateTokens()
    }
    
    func createStock(phone: String?, address: String?, details: String?) -> ApiTask<StockVO, UserModelError> {
        let task = ApiTask<StockVO, UserModelError>()
        task.dataRequest = stockService.createStock(phone: phone, address: address, details: details, response: task.defaultHandler())
        task.addSuccess {[weak self] stock in
            self?.stock = stock
        }.addFailure { error in
            print("Error creating stock: \(error)")
        }
        return task
    }
    
    func createTransaction(materials: [MaterialVO], receiverId: Int) -> ApiTask<TransactionVO, UserModelError> {

        let task = ApiTask<TransactionVO, UserModelError>()
        task.dataRequest = stockService.createTransaction(stockId: stock!.id, materials: materials, receiverId: receiverId, response: task.defaultHandler())
        return task
    }
}

extension WalletModel {
    var isLoggedIn: Bool {
        return self.currentUser != nil
    }
}

extension WalletModel {
    var hasStock: Bool {
        return self.stock != nil
    }
}
