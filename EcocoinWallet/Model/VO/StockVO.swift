//
//  StockVO.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 "transactions": [],
 "types": [],
 "id": 5,
 "phone": "0 (50) 889 13 32 ",
 "address": "Kyiv",
 "hours": "",
 "details": "Daily from 9:00 to 18:00",
*/
struct StockVO {
    var id: Int
}

extension StockVO: Mappable {
    
    mutating func mapping(map: Map) {
        id <- map["id"]
    }
    
    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        
        id = 0
    }
    
}
