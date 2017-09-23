//
//  URLExtensions.swift
//  HiveOnline
//
//  Created by Andrey Bogushev on 8/28/17.
//  Copyright © 2017 Seductive. All rights reserved.
//

import Foundation

extension URL {
    var statusCodeFromPath: Int? {
        let suffix = deletingPathExtension().absoluteString.characters.suffix(3)
        return Int(String(suffix))
    }
}
