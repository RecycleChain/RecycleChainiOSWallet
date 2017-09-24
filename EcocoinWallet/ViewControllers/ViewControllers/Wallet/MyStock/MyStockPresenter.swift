//
//  MyStockPresenter.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation

protocol MyStockView: class {
    func showStock(stock: StockVO)
    func showCreateStock()
    func showStockCreationError(error: String)
}

protocol MyStockPresenter {
    func appear()
    func createStock(phone: String?, address: String?, details: String?)
}

class MyStockPresenterImpl: MyStockPresenter {
    weak var view: MyStockView?
    var walletModel: WalletModel
    
    init(view: MyStockView?, walletModel: WalletModel) {
        self.view = view
        self.walletModel = walletModel
    }
    
    func createStock(phone: String?, address: String?, details: String?) {
        self.walletModel.createStock(phone: phone, address: address, details: details).addSuccess {[weak self] stock in
            self?.view?.showStock(stock: stock)
        }.addFailure {[weak self] error in
            self?.view?.showStockCreationError(error: "Cannot create a stock.")
        }
    }
    
    func appear() {
        self.walletModel.loadStocks().addCompletion {[weak self] in
            
            guard let this = self else {
                return
            }
            
            if let stock = this.walletModel.stock {
                this.view?.showStock(stock: stock)
            } else {
                this.view?.showCreateStock()
            }
        }
    }
}
