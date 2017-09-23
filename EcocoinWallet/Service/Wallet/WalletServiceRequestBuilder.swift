//
//  WalletServiceRequestBuilder.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import Alamofire

protocol WalletServiceRequestBuilderProtocol: BaseServiceRequestBuilderProtocol, URLRequestConvertible {
    init (token: String?)
    func balance() -> WalletServiceRequestBuilderProtocol
}

class WalletServiceRequestBuilder: WalletServiceRequestBuilderProtocol {
    
    var token: String?
    var route: (method: HTTPMethod, path: String, parameters: [String : Any]?)!
    
    required init(token: String? = nil) {
        self.token = token
    }
    
    func balance() -> WalletServiceRequestBuilderProtocol {
        self.route = (.get, "/api/wallet/balance", [:])
        return self
    }
}
