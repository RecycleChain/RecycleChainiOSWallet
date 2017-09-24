//
//  UserTransactionVO.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserTransactionVO {
    var id: Int
    var date: Date
    var amount: Double
    var currency: String
    
    init(id: Int, date: Date, amount: Double, currency: String) {
        self.id = id
        self.date = date
        self.amount = amount
        self.currency = currency
    }
}

extension UserTransactionVO: Mappable {
    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        id = 0
        date = Date()
        amount = 0
        currency = "EC"
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        date <- (map["date"], DateTransform())
        amount <- map["amount"]
        currency <- map["currency"]
    }
}
