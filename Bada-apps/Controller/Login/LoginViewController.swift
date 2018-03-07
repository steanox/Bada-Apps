//
//  LoginViewController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class LoginViewController: BaseController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
    }
    
    override func styleUI() {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.loginTextField.frame.height))
        
        loginTextField.leftView = paddingView
        loginTextField.leftViewMode = UITextFieldViewMode.always
        
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        
        loginTextField.layer.borderColor = UIColor(rgb: Color.formColor).cgColor
        passwordTextField.layer.borderColor = UIColor(rgb: Color.formColor).cgColor
        
    }
    
    
    @IBAction func handleLogin(){
        
    }
    
}

