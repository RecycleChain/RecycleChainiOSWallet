//
//  WalletVO.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserBalanceVO: Mappable {
    
    var balance: String = "0.0"
    init?(map: Map) { }
    
    init(balance: String) {
        self.balance = balance
    }
    
    mutating func mapping(map: Map) {
        balance <- map["balance"]
    }
}
