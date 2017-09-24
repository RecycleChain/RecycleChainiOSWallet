//
//  MyStockViewController.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit
import PKHUD
class MyStockViewController: UIViewController, MyStockView {
    
    var presenter: MyStockPresenter?
    
    @IBOutlet weak var tableView: UITableView!
    private var createStockView: StockCreateFooterView?
    
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
    
    func showStock(stock: StockVO) {
        HUD.hide()
        createStockView?.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func showCreateStock() {
        if createStockView == nil {
            createStockView = Bundle.main.loadNibNamed("StockCreateFooterView", owner: nil, options: nil)?.first as? StockCreateFooterView
            view.addSubview(createStockView!)
            createStockView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            createStockView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            createStockView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            createStockView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            createStockView?.saveButton.addTarget(self, action: #selector(createStock), for: .touchUpInside)
        }
        
        createStockView?.isHidden = false
        tableView.isHidden = true
    }
    
    func showStockCreationError(error: String) {
        HUD.flash(.labeledError(title: "Error", subtitle: error), delay: 1.5)
    }
    
    @objc func createStock() {
        HUD.show(.progress)
        presenter?.createStock(
            phone: createStockView?.phoneTextField.text,
            address: createStockView?.locationTextField.text,
            details: createStockView?.detailsTextView.text
        )
    }
    
    @objc func showAcceptRecyclebles() {
        self.performSegue(withIdentifier: "showAcceptRecyclebles", sender: self)
    }
}

extension MyStockViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = Bundle.main.loadNibNamed("StockTokensFooterView", owner: nil, options: nil)?.first as? StockTokensFooterView
            view?.secondButton.addTarget(self, action: #selector(showAcceptRecyclebles), for: .touchUpInside)
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 118
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "My Details"
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenTypeCell") as! TokenTypeTableViewCell
        
        if indexPath.row == 0 {
            cell.tokenTypeLabel.text = "Paper"
            cell.tokenPriceLabel.text = "100 kg | 10 EC"
        } else {
            cell.tokenTypeLabel.text = "Bio"
            cell.tokenPriceLabel.text = "1000 kg | 9 EC"
        }
 
        return cell
    }
    
    
}
