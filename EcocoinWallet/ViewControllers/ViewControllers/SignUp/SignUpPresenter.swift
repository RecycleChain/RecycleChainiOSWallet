//
//  SignUpPresenter.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation

protocol SignUpPresenter {
    func appear()
    func signUp(firstName: String, lastName: String, email: String, password: String)
}

protocol SignUpView: class {
    func showSignUpSuccess()
    func showSignUpError()
}

class SignUpPresenterImpl: SignUpPresenter {
    weak var view: SignUpView?
    var walletModel: WalletModel
    
    init(view: SignUpView, walletModel: WalletModel) {
        self.view = view
        self.walletModel = walletModel
    }
    
    func appear() {}
    
    func signUp(firstName: String, lastName: String, email: String, password: String) {
        walletModel.signup(credentials: LoginCredentialsVO(firstName: firstName, lastName: lastName, email: email, password: password)).addSuccess {[weak self] _ in
            self?.view?.showSignUpSuccess()
        }.addFailure {[weak self] _ in
            self?.view?.showSignUpError()
        }
    }
}
