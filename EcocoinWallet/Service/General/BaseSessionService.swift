//
//  BaseSessionService.swift
//  HiveOnline
//
//  Created by andreyb on 6/26/17.
//  Copyright © 2017 Seductive. All rights reserved.
//

import Foundation
import Alamofire

class BaseSessionService {
    
    class var baseURL:URL {
//      let string = Bundle.main.infoDictionary!["API_SERVER"] as! String
        let string = "http://localhost:3000"
        return URL(string: string)!
    }
    
    let manager: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        return SessionManager(configuration: configuration)
    }()
    
    func requestWrapper(_ request: URLRequestConvertible) -> DataRequest {
        return manager.request(request)
    }
}
