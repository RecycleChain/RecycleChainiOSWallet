//
//  StockService.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

protocol StockService {
    var token:String? { set get }
    func stocks(response: @escaping((DataResponse<[StockVO]>)->Void)) -> DataRequest
    func mystocks(response: @escaping((DataResponse<[StockVO]>)-> Void)) -> DataRequest
    func createStock(phone: String?, address: String?, details: String?, response: @escaping((DataResponse<StockVO>)-> Void)) -> DataRequest
    func createTransaction(stockId: Int, materials: [MaterialVO], receiverId: Int, response: @escaping((DataResponse<TransactionVO>)-> Void)) -> DataRequest
}

class StockServiceImpl: BaseSessionService, StockService {
    
    /** Private **/
    
    private func request<T: BaseMappable>(_ route: URLRequestConvertible, response:@escaping ((DataResponse<T>)->Void)) -> DataRequest {
        return manager.request(route).responseObject(completionHandler: response)
    }
    
    private func request<T: BaseMappable>(_ route: URLRequestConvertible, response:@escaping ((DataResponse<[T]>)->Void)) -> DataRequest {
        return manager.request(route).responseArray(completionHandler: response)
    }
    
    /** Public **/
    
    var token: String?
    func stocks(response: @escaping((DataResponse<[StockVO]>)->Void)) -> DataRequest {
        let request = StockServiceRequestBuilder(token: token).stocks()
        return self.request(request, response: response)
    }
    
    func mystocks(response: @escaping((DataResponse<[StockVO]>)-> Void)) -> DataRequest {
        let request = StockServiceRequestBuilder(token: token).mystock()
        return manager.request(request).responseArray(queue: nil, keyPath: "stocks", context: nil, completionHandler: response)        
    }

    func createStock(phone: String?, address: String?, details: String?, response: @escaping((DataResponse<StockVO>)-> Void)) -> DataRequest {
        let request = StockServiceRequestBuilder(token: token).createstock(phone: phone, address: address, details: details)
        return manager.request(request).responseObject(completionHandler: response)
    }
    
    func createTransaction(stockId: Int, materials: [MaterialVO], receiverId: Int, response: @escaping((DataResponse<TransactionVO>)-> Void)) -> DataRequest {
        let request = StockServiceRequestBuilder(token: token).createtransaction(stockId: stockId, materials: materials, receiverId: receiverId)
        return manager.request(request).responseObject(queue: nil, keyPath: "transaction", context: nil, completionHandler: response)
    }
}
