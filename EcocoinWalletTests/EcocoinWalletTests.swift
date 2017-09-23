//
//  EcocoinWalletTests.swift
//  EcocoinWalletTests
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import XCTest
@testable import EcocoinWallet

class EcocoinWalletTests: XCTestCase {
    
    var authService: AuthService!
    var walletsModel: WalletModel!
    
    override func setUp() {
        super.setUp()
        
        self.authService = AuthServiceImpl()
        self.walletsModel = WalletModelImpl(authService: authService)
    }
    
    override func tearDown() {
        self.authService = nil
        self.walletsModel = nil
        super.tearDown()
    }
    
    func testAuth() {
        
        expectUntil("user signup 1") { done in
            walletsModel.signup(credentials:
                LoginCredentialsVO(firstName: "Kirill", lastName: "Kirikov", email: "olmer.k@gmail.com", password: "inside90"))
                .addSuccess { (user: UserVO) in
                    XCTAssertNotNil(user)
                    XCTAssertNotNil(user.token)
                    XCTAssertEqual(user.email, "olmer.k@gmail.com")
                    XCTAssertEqual(user.id, 1)
                    done()
                }.addFailure { (error: UserModelError) in
                    XCTAssertNotNil(error, "should not be nil")
                    done()
            }
        }
    }
}
