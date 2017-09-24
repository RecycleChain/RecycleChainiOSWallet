//
//  TransactionVO.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation

import ObjectMapper

struct TransactionVO: Mappable {
    var id: Int
    
    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        
        id = 0
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
    }
}
