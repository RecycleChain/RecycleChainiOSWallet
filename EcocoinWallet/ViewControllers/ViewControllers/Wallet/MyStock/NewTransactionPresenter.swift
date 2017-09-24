//
//  NewTransactionPresenter.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation

protocol NewTransactionPresenter {
    func addMaterial(material: MaterialVO)
    func removeMaterial(at index: Int)
    func setScanned(id: Int)
    func createTransaction()
}

protocol NewTransactionView: class {
    func showMaterials(materials: [MaterialVO])
    func showTransactionCreatedSuccessfully()
    func showTransactionCreatedWithError(error: String)
    func showProgress()
}

class NewTransactionPresenterImpl: NewTransactionPresenter {
    
    private weak var view: NewTransactionView?
    private var walletModel: WalletModel
    private var scannedId: Int?
    
    private var materials: [MaterialVO] = []
    
    init(view: NewTransactionView?, walletModel: WalletModel) {
        self.view = view
        self.walletModel = walletModel
    }
    
    func createTransaction() {
        
        if let scannedId = scannedId, materials.count > 0 {
            self.view?.showProgress()
            self.walletModel.createTransaction(
                materials: materials,
                receiverId: scannedId
            ).addSuccess({[weak self] _ in
                self?.view?.showTransactionCreatedSuccessfully()
            }).addFailure({[weak self] error in
                self?.view?.showTransactionCreatedWithError(error: "Error during creating the transaction.")
            })
        }
    }
    
    func setScanned(id: Int) {
        self.scannedId = id
    }
    
    func addMaterial(material: MaterialVO) {
        materials.append(material)
        view?.showMaterials(materials: materials)
    }
    
    func removeMaterial(at index: Int) {
        materials.remove(at: index)
        view?.showMaterials(materials: materials)
    }
}
