//
//  ForumLobbyVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit

class ForumLobbyViewController: UIViewController {
   
    var seletectedTitle: String?
    var articleArray = [PostArticleModel]()
    
    @IBOutlet weak var forumLobbyUITableView: UITableView!
    @IBOutlet weak var postArticleButton: UIButton!
    
    // postInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        forumLobbyUITableView.delegate = self
        forumLobbyUITableView.dataSource = self
        
        style()
    }
    
    func style() {
        
        // title
        self.title = "\(seletectedTitle ?? "")"
        
        // backTabBar
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        // View
        self.view.backgroundColor = .white
        
        // postArticleButton
        postArticleButton.layer.cornerRadius = postArticleButton.frame.width / 2
    }
}

extension ForumLobbyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = forumLobbyUITableView.dequeueReusableCell(withIdentifier: "Cell",
                                                                   for: indexPath) as? ForumLobbyTableViewCell else {
            
            fatalError("can't find ForumLobbyTableViewCell")
        }
        
//        cell.titleLabel.text = articleArray[0].title
//        cell.authorLabel.text = articleArray[0].authorName
//        cell.contentLabel.text = articleArray[0].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ForumDetailSegue", sender: self)
        print(indexPath.row)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let destination = segue.destination as? ForumDetailViewController,
//           let selectedRow = forumLobbyUITableView.indexPathForSelectedRow?.row {
//            destination.titleLabel.text =
//            destination.contentLabel.text =
//            destination.postNameLabel.text = articleArray[selectedRow].authorName
//        }
//    }
}

extension ForumLobbyViewController: UITableViewDelegate {
    
}
