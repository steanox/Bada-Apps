//
//  DetailNewsController.swift
//  Bada-apps
//
//  Created by octavianus on 22/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import WebKit
import FirebaseFirestore


class DetailNewsViewController: BaseController{
    
    var newsID: String? = nil
    let ref = Firestore.firestore()
    
    @IBOutlet weak var contentView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        startActivityIndicator()
        
        self.navigationItem.title = "News"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
        
        if let id = newsID{
            ref.collection("news").document(id).getDocument { (document, error) in
                if error != nil{
                    return
                }
                
                let data = document?.data()
                
                self.contentView.loadHTMLString(data!["content"] as! String, baseURL: nil)
                self.stopActivityIndicator()
            }
        }

    }
    
    @objc func handleShare(){
        self.view.showNotification(title: "Sorry 😣", description: "This Feature not available yet", buttonText: "Close") {
            
        }
    }
    
    
    
}
