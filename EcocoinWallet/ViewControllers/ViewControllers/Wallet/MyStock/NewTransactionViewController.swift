//
//  NewTransactionViewController.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit
import SwiftQRCode
import PKHUD

class NewTransactionViewController: UIViewController, NewTransactionView {
    
    @IBOutlet weak var qrCodeCameraView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: NewTransactionPresenter?
    
    private let scanner = QRCode()
    fileprivate var materials:[MaterialVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner.prepareScan(qrCodeCameraView) {[weak self] value in
            print("Scanned value: \(value)")
            if let string = value.split(separator: ":").last {
                if let id = Int(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
                    print("ID Scanned: \(id)")
                    self?.presenter?.setScanned(id: id)
                }
            }
        }
        scanner.scanFrame = qrCodeCameraView.bounds
        
        let approve = UIBarButtonItem(title: "Approve", style: .done, target: self, action: #selector(createTransaction))
        self.navigationItem.rightBarButtonItem = approve
    }
    
    @objc func createTransaction() {
        self.presenter?.createTransaction()
    }
    
    static var typeIndex: Int = 0
    
    @IBAction func addMaterial(_ sender: Any) {
        /*
        let types = [
            MaterialVO(type: "Paper", amount: 399),
            MaterialVO(type: "Bio", amount: 20),
            MaterialVO(type: "Bio", amount: 15),
            MaterialVO(type: "Bio", amount: 30),
            MaterialVO(type: "Paper", amount: 40),
            MaterialVO(type: "Paper", amount: 100),
            MaterialVO(type: "Paper", amount: 1)
        ]
        
        presenter?.addMaterial(material: types[NewTransactionViewController.typeIndex])
        NewTransactionViewController.typeIndex = (NewTransactionViewController.typeIndex + 1) % types.count
         */
        presenter?.addMaterial(material: MaterialVO(type: "Paper", amount: 399))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scanner.startScan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: NewTransactionView
    
    func showMaterials(materials: [MaterialVO]) {
        self.materials = materials
        self.tableView.reloadData()
    }
    
    func showTransactionCreatedSuccessfully() {
        HUD.hide()
        self.navigationController?.popToRootViewController(animated: true)
    }
    func showTransactionCreatedWithError(error: String) {
        HUD.flash(.labeledError(title: "Error", subtitle: error), delay: 1.5)
    }
    func showProgress() {
        HUD.show(.progress)
    }
}

extension NewTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMaterialCell") as! TransactionAddMaterialTableViewCell
        let material = self.materials[indexPath.row]
        
        cell.materialLabel.text = material.type
        cell.changeAmountButton.setTitle("\(material.amount) kg", for: .normal)
        cell.changePriceButton.setTitle("\(material.amount) EC", for: .normal)
        
        cell.changeAmountCallback = {[weak self] (sender) in
            
        }
        cell.removeCallback = {[weak self] (sender) in
            if let indexPath = self?.tableView.indexPath(for: cell) {
                self?.presenter?.removeMaterial(at: indexPath.row)
            }
        }
        return cell
    }
}
