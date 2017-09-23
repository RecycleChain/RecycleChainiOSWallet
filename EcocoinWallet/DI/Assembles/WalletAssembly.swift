//
//  AuthAssembly.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//


import Foundation
import Swinject

final class WalletAssembly: Assembly {
    
    func assemble(container: Container) {

        container.storyboardInitCompleted(WalletViewController.self) { (r, c) in
            c.presenter = WalletPresenterImpl(view: c, model: r.resolve(WalletModel.self)!)
        }
        
        container.storyboardInitCompleted(SignInViewController.self) { (r, c) in
            c.presenter = SignInPresenterImpl(view: c, model: r.resolve(WalletModel.self)!)
        }
        
        container.storyboardInitCompleted(SignUpViewController.self) { (r, c) in
            c.presenter = SignUpPresenterImpl(view: c, walletModel: r.resolve(WalletModel.self)!)
        }
 
        container.register(WalletModel.self) { r in
            let authService = r.resolve(AuthService.self)!
            let walletService = r.resolve(WalletService.self)!
            return WalletModelImpl(authService: authService, walletService: walletService)
        }.inObjectScope(.weak)
        
        container.register(AuthService.self) { r in
            AuthServiceImpl()
        }
        
        container.register(WalletService.self) { r in
            WalletServiceImpl()
        }

    }
}
