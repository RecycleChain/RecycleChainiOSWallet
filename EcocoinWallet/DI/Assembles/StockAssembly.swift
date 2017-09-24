//
//  StockAssembly.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import Swinject

final class StockAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.storyboardInitCompleted(MyStockViewController.self) { r, c in
            c.presenter = MyStockPresenterImpl(view: c, walletModel: r.resolve(WalletModel.self)!)
        }
        
        container.register(StockService.self) { r in
            StockServiceImpl()
        }
        
    }
}
