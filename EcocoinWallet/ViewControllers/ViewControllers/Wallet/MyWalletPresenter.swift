//
//  MyWalletPresenter.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import QRCode

protocol MyWalletPresenter {
    func appear()
}

protocol MyWalletView: class {
    func showBalance(balance: UserBalanceVO)
    func showQRCodeImage(image: UIImage)
    func showBalanceLoading()
    func showTransactionsLoadingIndicator()
    func hideTransactionsLoadingIndicator()
    func showTransactions(transactions: [UserTransactionVO])
}

class MyWalletPresenterImpl: MyWalletPresenter {
    weak var view: MyWalletView?
    var model: WalletModel
    
    init(view: MyWalletView, model: WalletModel) {
        self.view = view
        self.model = model
    }
    
    func appear() {
        if model.isLoggedIn {
            createQRCode()
            loadBalance()
            loadTransactions()
        }
    }

    private func loadTransactions() {
        view?.showTransactionsLoadingIndicator()
        model.loadTransactions().addCompletion {[weak self] in
            self?.view?.hideTransactionsLoadingIndicator()
            if let transactions = self?.model.transactions {
                self?.view?.showTransactions(transactions: transactions)
            }
        }
    }
    
    private func loadBalance() {
        view?.showBalanceLoading()
        
        if let balance = model.currentBalance {
            view?.showBalance(balance: balance)
        }
        
        model.loadBalance().addSuccess {[weak self] balance in
            self?.view?.showBalance(balance: balance)
        }
    }
    
    private func createQRCode() {
        if let currentUser = model.currentUser {
            var qrcode = QRCode("ID: \(currentUser.id)")
            qrcode?.size = CGSize(width: 300, height: 300)
            if let image = qrcode?.image {
                view?.showQRCodeImage(image: image)
            }
        }
    }
}
