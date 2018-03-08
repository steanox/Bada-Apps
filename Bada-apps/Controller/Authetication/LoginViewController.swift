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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

        
//        loginTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.loginTextField.frame.height))
//        loginTextField.leftViewMode = UITextFieldViewMode.always
//        
//        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.loginTextField.frame.height))
//        passwordTextField.leftViewMode = UITextFieldViewMode.always
        

        
//        loginTextField.layer.borderColor = UIColor(rgb: Color.formColor).cgColor
//        passwordTextField.layer.borderColor = UIColor(rgb: Color.formColor).cgColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    
    
    @IBAction func handleLogin(){

        view.showNotification(title: "SUCCESS", description: "wew", buttonText: "OK")



    }
    
}

