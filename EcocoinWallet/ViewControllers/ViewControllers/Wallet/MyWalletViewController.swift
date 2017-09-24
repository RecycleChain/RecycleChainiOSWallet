//
//  MyWalletViewController.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController, MyWalletView {

    var presenter: MyWalletPresenter?
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionsLoadingIndicator: UIActivityIndicatorView!
    
    fileprivate var transactions: [UserTransactionVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.appear()
    }

    //MARK: MyWalletView
    
    func showBalanceLoading() {
        self.balanceLabel.text = "Loading"
    }
    
    func showTransactionsLoadingIndicator() {
        self.transactionsLoadingIndicator.isHidden = false
        self.transactionsLoadingIndicator.startAnimating()
    }
    
    func hideTransactionsLoadingIndicator() {
        self.transactionsLoadingIndicator.isHidden = true
        self.transactionsLoadingIndicator.stopAnimating()
    }
    
    func showTransactions(transactions: [UserTransactionVO]) {
        self.transactions = transactions
        self.tableView.reloadData()
    }
    
    func showBalance(balance: UserBalanceVO) {
        self.balanceLabel.text = "\(Double(balance.balance)!) EC"
    }
    
    func showQRCodeImage(image: UIImage) {
        qrCodeImageView.image = image
    }

}

extension MyWalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        let transaction = transactions[indexPath.row]
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy hh:mm a"
        
        cell.dateTimeLabel.text = df.string(from: transaction.date)
        cell.amountLabel.text = "\(transaction.amount) \(transaction.currency)"
        
        return cell
    }
    
}

