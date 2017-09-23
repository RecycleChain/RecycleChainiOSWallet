
//
//  XCTestExtentions.swift
//  HiveOnline
//
//  Created by Andrey Bogushev on 8/21/17.
//  Copyright © 2017 Seductive. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func expectUntil(_ description: String? = nil, timeout: TimeInterval? = nil, completion: (@escaping () -> Void) -> Void) {
        weak var done = expectation(description: description ?? "")
        
        completion({
            guard let promise = done else {
                return
            }
            promise.fulfill()
        })
        
        waitForExpectations(timeout: timeout ?? 1.0) { error in
            if let e = error {
                XCTFail("\(done) - \(e.localizedDescription)")
            }
        }
    }
}
