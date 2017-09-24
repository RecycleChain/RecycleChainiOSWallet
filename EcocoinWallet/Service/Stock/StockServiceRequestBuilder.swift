//
//  StockServiceRequestBuilder.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import Alamofire

protocol StockServiceRequestBuilderProtocol: BaseServiceRequestBuilderProtocol, URLRequestConvertible {
    init (token: String?)
    func stocks() -> StockServiceRequestBuilderProtocol
    func mystock() -> StockServiceRequestBuilderProtocol
    func createstock(phone: String?, address: String?, details: String?) -> StockServiceRequestBuilderProtocol
    func createtransaction(stockId: Int, materials: [MaterialVO], receiverId: Int) -> StockServiceRequestBuilderProtocol
}

class StockServiceRequestBuilder: StockServiceRequestBuilderProtocol {
    
    var token: String?
    var route: (method: HTTPMethod, path: String, parameters: [String : Any]?)!
    
    required init(token: String? = nil) {
        self.token = token
    }
    
    func stocks() -> StockServiceRequestBuilderProtocol {
        self.route = (.get, "/api/stock", [:])
        return self
    }
    
    func mystock() -> StockServiceRequestBuilderProtocol {
        self.route = (.get, "/api/stock/my", [:])
        return self
    }
    
    func createstock(phone: String?, address: String?, details: String?) -> StockServiceRequestBuilderProtocol {
        var params: [String: String] = [:]
        if let phone = phone {
            params["phone"] = phone
        }
        if let address = address {
            params["address"] = address
        }
        if let details = details {
            params["details"] = details
        }
        
        params["hours"] = ""
        
        self.route = (.post, "/api/stock", params)
        return self
    }
    
    func createtransaction(stockId: Int, materials: [MaterialVO], receiverId: Int) -> StockServiceRequestBuilderProtocol {
        self.route = (.post, "/api/transaction/\(stockId)/\(receiverId)", ["trash": materials.toJSON()])
        return self
    }
}
