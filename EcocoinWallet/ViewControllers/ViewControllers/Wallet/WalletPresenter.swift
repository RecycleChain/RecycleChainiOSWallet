//
//  WalletPresenter.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation

protocol WalletPresenter {
    func appear()
    func logout()
}

protocol WalletView: class {
    func replaceWithSignIn()
    func showBalance(balance: UserBalanceVO)
}

class WalletPresenterImpl: WalletPresenter {
    weak var view: WalletView?
    var model: WalletModel
    
    init(view: WalletView, model: WalletModel) {
        self.view = view
        self.model = model
    }
    
    func appear() {
        if model.isLoggedIn {
            loadBalance()
        } else {
            view?.replaceWithSignIn()
        }
    }
    
    func logout() {
        model.logout()
        view?.replaceWithSignIn()
    }
    
    private func loadBalance() {
        model.loadBalance().addSuccess {[weak self] balance in
            self?.view?.showBalance(balance: balance)
        }
    }
}
