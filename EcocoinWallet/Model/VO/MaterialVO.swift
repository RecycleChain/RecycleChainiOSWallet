//
//  MaterialVO.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct MaterialVO {
    var type: String
    var amount: Double
}

extension MaterialVO: Mappable {
    init?(map: Map) {
        type = "Paper"
        amount = 10
    }
    
    mutating func mapping(map: Map) {
        type <- map["type"]
        amount <- map["amount"]
    }
}
