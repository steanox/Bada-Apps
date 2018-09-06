//
//  Account.swift
//  Bada-apps
//
//  Created by Handy Handy on 14/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: BaseController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTableView: UITableView!
    
    let accountArray = [Message.changePassword, Message.signOut]
    
    let dispatchGroup: DispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTableView.delegate = self
        accountTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setupNavigationBar()
        setupInitialView()
    }
    
    func setupInitialView() {
        nameLabel.text = Message.worldClassDeveloper
        nameLabel.textColor = UIColor.init(rgb: Color.textColor)
        //
        accountImageView.layer.cornerRadius = accountImageView.frame.width / 2.0
        accountImageView.layer.masksToBounds = true
        //
        
        view.shimmer(state: .start,
                     views: nameLabel, accountImageView, accountTableView)
        
        startRequest()
    }
    
    func startRequest() {
        getUserName()
        getUserPhoto()
        dispatchGroup.notify(queue: .main) {
            self.view.shimmer(state: .stop,
                              views: self.nameLabel, self.accountImageView, self.accountTableView)
        }
    }
    
    func getUserName() {
        dispatchGroup.enter()
        User.getUser().getName {[weak self] (name) in
            guard let name = name else {return}
            self?.dispatchGroup.leave()
            self?.nameLabel.text = name
        }
        
    }
    
    private func getUserPhoto(){
        dispatchGroup.enter()
        User.getProfilePictureURL {[weak self] (profilePictureURL) in
            self?.dispatchGroup.leave()
            if profilePictureURL == "" {
                self?.accountImageView.image = #imageLiteral(resourceName: "ProfilePictDummy")
            }else{
                self?.accountImageView.loadImageUsingCacheWith(urlString: profilePictureURL,done: nil)
            }
        }
    }
    
    func userTryingToSignOut() {
        loadingIndicator?.startLoading()
        User.logout(onSuccess: {
            self.loadingIndicator?.stopLoading()
            let authSB = UIStoryboard(name: Identifier.authentication, bundle: nil).instantiateInitialViewController() as! LoginViewController
            self.present(authSB, animated: true, completion: nil)
        }) { (error) in
            self.loadingIndicator?.stopLoading()
            self.view.showNotification(title: Message.signOut, description: error.localizedDescription, buttonText: Message.close, onSuccess: nil)
        }
    }
    
}


// MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.accountCell, for: indexPath)
        
        if accountArray[indexPath.row] == Message.signOut {
            cell.textLabel?.textColor = UIColor.red
        }else {
            cell.textLabel?.textColor = UIColor.init(rgb: Color.textColor)
        }
        cell.textLabel?.text = accountArray[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch accountArray[indexPath.row] {
        case Message.changePassword:
            print(Message.changePassword)
        case Message.signOut:
            userTryingToSignOut()
        default:
            print("Error")
        }
    }
    
}







