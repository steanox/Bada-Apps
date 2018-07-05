//
//  LoginViewController.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorText: UILabel!
    var pushedHeight: CGFloat?
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        errorText.text = ""
        loginTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    @IBAction func handleLogin(){
        startActivityIndicator()
        errorText.text = ""
        
        guard
            let email = loginTextField.text,
            let password = passwordTextField.text
            else { return }
        
        
        User.login(email: email, password: password,  onSuccess: {[weak self] (r) in
            let sb = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! RootTabBarController
            self?.stopActivityIndicator()
            self?.present(sb, animated: true) {

            }
        }) { [weak self] (error) in
            self?.stopActivityIndicator()
            self?.errorText.text = "Invalid apple ID or password"
        }

   }
    
}

extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField{
            
            if (passwordTextField.text?.isEmpty)!{
                passwordTextField.becomeFirstResponder()
            }else{
                loginTextField.resignFirstResponder()
            }
        }else{
            if (loginTextField.text?.isEmpty)!{
                loginTextField.becomeFirstResponder()
            }else{
                passwordTextField.resignFirstResponder()
            }
        }
        
        return true
    }
    
    
    
//    @objc func keyboardWillShow(notification: NSNotification) {
        //        print(self.view.frame.origin.y)
        //
        //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //
        //            if self.view.frame.origin.y == 0{
        //
        //                let minYKeyboard = view.frame.height - keyboardSize.height
        //                print("frame: \(view.frame.height)")
        //                print("keyboardSize: \(keyboardSize.height)")
        //
        //                let intersectionWithButton = submitButton.frame.maxY - minYKeyboard
        //
        //
        //                if intersectionWithButton > 0{
        //                    let padding = CGFloat(30)
        //                    pushedHeight = intersectionWithButton + padding
        //                    print("pushed Height: \(pushedHeight)")
        //                    self.view.frame.origin.y -= pushedHeight!
        //                }
        //
        //
        //            }else{
        //                self.view.frame.origin.y += pushedHeight!
        //            }
        //        }
        
//    }
    
    
    
    
    
}
