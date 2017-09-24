//
//  WalletViewController.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, WalletView {

    @IBOutlet weak var screenTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var myWalletContainer: UIView!
    @IBOutlet weak var myStockContainer: UIView!
    
    var presenter: WalletPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMyWallet()
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
    
    @IBAction func changeScreenType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: showMyWallet()
        default: showMyStock()
        }
    }
    
    //MARK: WalletView
    
    func replaceWithSignIn() {
        self.performSegue(withIdentifier: "ReplaceWithSignIn", sender: self)
    }
    
    func showMyWallet() {
        self.myWalletContainer.isHidden = false
        self.myStockContainer.isHidden = true
    }
    
    func showMyStock() {
        self.myWalletContainer.isHidden = true
        self.myStockContainer.isHidden = false
    }
}
