//
//  WalletPresenter.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation

protocol WalletPresenter {
    
}

protocol WalletView: class {
    
}

class WalletPresenterImpl: WalletPresenter {
    var view: WalletView?
    var model: WalletModel?
    init(view: WalletView?, model: WalletModel?) {
        self.view = view
        self.model = model
    }
}
