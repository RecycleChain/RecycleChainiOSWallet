//
//  WalletPresenter.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import QRCode

protocol WalletPresenter {
    func appear()
    func logout()
}

protocol WalletView: class {
    func replaceWithSignIn()
    func showMyWallet()
    func showMyStock()
}

class WalletPresenterImpl: WalletPresenter {
    weak var view: WalletView?
    var model: WalletModel
    
    init(view: WalletView, model: WalletModel) {
        self.view = view
        self.model = model
    }
    
    func appear() {
        if !model.isLoggedIn {
            view?.replaceWithSignIn()
        } else {
            view?.showMyWallet()
        }
    }
    
    func logout() {
        model.logout()
        view?.replaceWithSignIn()
    }
}
