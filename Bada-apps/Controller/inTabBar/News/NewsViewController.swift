//
//  News.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import WebKit
import FirebaseFirestore


class NewsViewController: BaseController {
    
   
    var ref = Firestore.firestore()
    
    var newsData: [News] = []
    var selectedID: String = ""
    
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        fetchNewsFromDatabase()
    }
    
    func fetchNewsFromDatabase(){
        self.startActivityIndicator()
        
        self.ref.collection("news").getDocuments{ (snapshot, error) in
            if error != nil {
                return
            }
            
            for document in snapshot!.documents{
                let news = document.data()
                self.newsData.append(News(id: document.documentID,title: news["title"] as! String))
            }
            
            self.newsTableView.reloadData()
            self.stopActivityIndicator()
            
        }
    }
    
    @IBAction func refreshData(){
        newsData = []
        fetchNewsFromDatabase()
    }
}

extension NewsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        cell.textLabel?.text = newsData[indexPath.row].title
        return cell
    }
}


extension NewsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedID = newsData[indexPath.row].documentID
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let dest = segue.destination as! DetailNewsViewController
            dest.newsID = selectedID
            
        }
    }
    
    
}

