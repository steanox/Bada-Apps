//
//  RegisterViewController.swift
//  Bada-apps
//
//  Created by Octavianus . on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit


class RegisterViewController: BaseController{
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var errorText: UILabel!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleRegister(){
        startActivityIndicator()
        errorText.text = ""
        guard
            let email = emailField.text,
            let fullname = fullNameField.text,
            let birthDate = dateField.text
            else { return }
        
        
        User.register(appleID: email, fullName: fullname, dateOfBirth: birthDate, onSuccess: { [weak self] in
            
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
            }
            
            self?.view.showNotification(title: "Success", description: "Please check your email to get your password", buttonText: "OK", onSuccess: {[weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            //ON ERROR
        }) { [weak self] (error) in
            
            switch error{
            case UserCheck.wrongDateOfBirth:
                self?.errorText.text = "Please input your correct date of birth"
            case UserCheck.userNotExists:
                self?.errorText.text = "Your apple ID is not exists"
            case UserCheck.somethingWentWrong:
                self?.errorText.text = "Something went wrong please try again later"
            default:
                self?.errorText.text = error.localizedDescription
            }
            
            
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
            }
        }
        
    }
    
    
    
    @IBAction func backToLogin(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func specialDateTextFieldClick(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        dateField.inputView = datePickerView
        dateField.inputAccessoryView = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
        datePickerView.addTarget(self, action: #selector(datePickerFromValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @objc func dismissPicker() {
        
        self.becomeFirstResponder()
        
    }
    
}

