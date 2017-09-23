//
//  UserVo.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserVO {
    var id          : Int
    var firstName   : String
    var lastName    : String
    var email       : String
    var token       : String
}

struct LoginCredentialsVO {
    var firstName   : String?
    var lastName    : String?
    var email       : String
    var password    : String
}

extension UserVO: Mappable {
    
    init?(map: Map) {
        id = 0
        firstName = ""
        lastName = ""
        email = ""
        token = ""
    }
    
    mutating func mapping(map: Map) {
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        token <- map["token"]
        id <- map["id"]
    }
}
