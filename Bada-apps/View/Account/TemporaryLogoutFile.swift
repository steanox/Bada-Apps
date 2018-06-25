//
//  TemporaryLogoutFile.swift
//  Bada-apps
//
//  Created by octavianus on 25/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import FirebaseAuth

class TemporaryLogoutFile: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logout(){
        do{
            try Auth.auth().signOut()
            let authSB = UIStoryboard(name: "Authentication", bundle: nil).instantiateInitialViewController() as! LoginViewController
            present(authSB, animated: true, completion: nil)
        }catch{
            print("logout error")
        }
    }
    
}
