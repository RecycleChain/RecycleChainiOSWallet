//
//  BaseService.swift
//  HiveOnline
//
//  Created by Kirill Kirikov on 6/12/17.
//  Copyright © 2017 Seductive. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

typealias JSON = [String: Any]

protocol Reason {
    var reason: String { get }
}

extension Error {
    var reason: String {
        return self.localizedDescription
    }
}

protocol InternalApiErrorConvertible {
    static func from(error: InternalApiError) -> Self
}

extension InternalApiError: Reason {
    
    var reason: String {
        switch self {
        case .httpError(_, let reason, _):
            return reason
        case .noData(let reason):
            return reason
        case .dataSerializationFailed(let reason):
            return reason
        case .serverError(let errors):
            return errors.joined()
        }
    }
}

enum InternalApiError: Error {
    
    case httpError(code: Int, reason: String, info: JSON?)
    case noData(reason: String)
    case dataSerializationFailed(reason: String)
    case serverError(errors: [String])
}


protocol BaseServiceRequestBuilderProtocol {
    static var baseURL:URL { get }
    var route: (method: Alamofire.HTTPMethod, path: String, parameters: JSON?)! { get }
    var token: String? { get set }
}

extension BaseServiceRequestBuilderProtocol {
    
    static var baseURL:URL {
        let string = Bundle.main.infoDictionary!["API_SERVER"] as! String
        return URL(string: string)!
    }
    
    var url: URL {
        if let pathString = route.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: pathString, relativeTo: BaseSessionService.baseURL)!
        } else {
            assert(false, "something wrong with path")
            return BaseSessionService.baseURL
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        
        if let token = self.token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        return try URLEncoding.default.encode(request, with: route.parameters)
    }
}
