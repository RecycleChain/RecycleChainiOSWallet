//
//  SignInViewController.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, SignInView {

    private var presenter: SignInPresenter?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        guard let email = self.loginTextField.text, let password = self.passwordTextField.text else {
            return
        }
        
        presenter?.signIn(email: email, password: password)
    }
    
    @IBAction func signUp(_ sender: Any) {
        
    }
    
    @IBAction func forgotPass(_ sender: Any) {
        
    }
    
    //MARK: SignInView
    
    func showSignInSuccess() {
        print("Signin success")
    }
    
}
