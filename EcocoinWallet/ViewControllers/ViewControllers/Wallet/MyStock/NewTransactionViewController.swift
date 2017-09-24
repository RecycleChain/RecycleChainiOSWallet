//
//  NewTransactionViewController.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit
import SwiftQRCode

class NewTransactionViewController: UIViewController {
    
    @IBOutlet weak var qrCodeCameraView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let scanner = QRCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner.prepareScan(qrCodeCameraView) { value in
            print("Scanned value: \(value)")
            if let string = value.split(separator: ":").last, let id = Int(string) {
                print("ID Scanned: \(id)")
            }
        }
        scanner.scanFrame = qrCodeCameraView.bounds
    }
    
    @IBAction func addMaterial(_ sender: Any) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scanner.startScan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
