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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        accountTableView.delegate = self
        accountTableView.dataSource = self
    }
    
    func setupNavigationBar() {
        var colors = [UIColor]()
        colors.append(UIColor.init(rgb: Color.profileImageColor))
        colors.append(UIColor.init(rgb: Color.attendanceImageColor))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    func setupInitialView() {
        setupNavigationBar()
        //
        nameLabel.text = Message.worldClassDeveloper
        nameLabel.textColor = UIColor.init(rgb: Color.textColor)
        //
        nameLabel.applySkimmerEffect()
        //
        accountImageView.applySkimmerEffect()
        accountImageView.layer.cornerRadius = accountImageView.frame.width / 2.0
        accountImageView.layer.masksToBounds = true
        //
        accountTableView.applySkimmerEffect()
        
    }
    
    @IBAction func check() {
        nameLabel.removeSkimmerEffect()
        accountImageView.removeSkimmerEffect()
        accountTableView.removeSkimmerEffect()
    }
    
    @IBAction func start() {
        nameLabel.applySkimmerEffect()
        accountImageView.applySkimmerEffect()
        accountTableView.applySkimmerEffect()
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
}







