//
//  SignUpViewController.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit
import PKHUD

class SignUpViewController: UIViewController, SignUpView {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var presenter: SignUpPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let fisrtName = self.firstNameTextField.text,
            let lastName = self.lastNameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text else {
                return
        }
        HUD.show(.progress)
        presenter?.signUp(firstName: fisrtName, lastName: lastName, email: email, password: password)
    }
    
    //MARK: SignUp View
    
    func showSignUpError() {
        HUD.flash(.error)
    }
    
    func showSignUpSuccess() {
        HUD.hide()
        navigationController?.popToRootViewController(animated: true)
    }
    
}
