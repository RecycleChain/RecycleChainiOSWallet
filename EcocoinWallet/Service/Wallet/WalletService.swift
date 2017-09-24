//
//  WalletService.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

protocol WalletService {
    
    var token:String? { set get }
    
    @discardableResult
    func balance(response: @escaping((DataResponse<UserBalanceVO>)->Void)) -> DataRequest
    
    @discardableResult
    func transactions(response: @escaping((DataResponse<[UserTransactionVO]>)->Void)) -> DataRequest
}

class WalletServiceImpl: BaseSessionService, WalletService {
    
    /** Private **/
    
    private func request<T: BaseMappable>(_ route: URLRequestConvertible, response:@escaping ((DataResponse<T>)->Void)) -> DataRequest {
        return manager.request(route).responseObject(completionHandler: response)
    }
    
    private func request<T: BaseMappable>(_ route: URLRequestConvertible, response:@escaping ((DataResponse<[T]>)->Void)) -> DataRequest {
        return manager.request(route).responseArray(completionHandler: response)
    }
    
    /** Public **/
    
    var token: String?
    func balance(response: @escaping((DataResponse<UserBalanceVO>)->Void)) -> DataRequest {
        let request = WalletServiceRequestBuilder(token: token).balance()
        return self.request(request, response: response)
    }
    
    func transactions(response: @escaping((DataResponse<[UserTransactionVO]>)->Void)) -> DataRequest {
        let request = WalletServiceRequestBuilder(token: token).transactions()
        return self.request(request, response: response)
    }
}
