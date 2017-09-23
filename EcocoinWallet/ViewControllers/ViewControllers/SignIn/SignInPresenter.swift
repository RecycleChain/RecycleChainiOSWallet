//
//  SignInPresenter.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation

protocol SignInView: class {
    func showSignInSuccess()
}

protocol SignInPresenter {
    func signIn(email: String, password: String)
}

class SignInPresenterImpl: SignInPresenter {
    
    private weak var view: SignInView?
    private var model: WalletModel?
    
    init(view: SignInView?, model: WalletModel?) {
        self.view = view
        self.model = model
    }
    
    func signIn(email: String, password: String) {
        self.model?.signin(credentials: LoginCredentialsVO(firstName: nil, lastName: nil, email: email, password: password)).addSuccess({[weak self] user in
            self?.view?.showSignInSuccess()
        })
    }
}
