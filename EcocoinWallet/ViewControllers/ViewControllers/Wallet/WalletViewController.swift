//
//  WalletViewController.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, WalletView {

    var presenter: WalletPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.appear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signOut(_ sender: Any) {
        presenter?.logout()
    }
    
    //MARK: WalletView
    
    func replaceWithSignIn() {
        self.performSegue(withIdentifier: "ReplaceWithSignIn", sender: self)
    }

    func showBalance(balance: UserBalanceVO) {
        
    }
    
}
