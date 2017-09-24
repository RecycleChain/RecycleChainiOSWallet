//
//  TransactionAddMaterialTableViewCell.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/24/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit

class TransactionAddMaterialTableViewCell: UITableViewCell {

    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var removeMaterialButton: UIButton!
    @IBOutlet weak var changeAmountButton: UIButton!
    @IBOutlet weak var changePriceButton: UIButton!
    
    var removeCallback: ((TransactionAddMaterialTableViewCell) -> Void)?
    var changeAmountCallback: ((TransactionAddMaterialTableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func remove(_ sender: Any) {
        removeCallback?(self)
    }
    
    @IBAction func changeAmount(_ sender: Any) {
        changeAmountCallback?(self)
    }
}
