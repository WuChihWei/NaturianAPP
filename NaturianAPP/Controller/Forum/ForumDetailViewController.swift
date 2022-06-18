//
//  ForumDetailViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//

import UIKit

class ForumDetailViewController: UIViewController {

    @IBOutlet weak var replyTableView: UITableView!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avatarUIImage: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    
    var didPostArticle: [PostArticleModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        replyTableView.dataSource = self
        replyTableView.delegate = self
    }
    
}

extension ForumDetailViewController: UITableViewDelegate {
    
}

extension ForumDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = replyTableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as? ForumDetailTableViewCell else {
            fatalError("can't find ForumDetailTableViewCell")
        }
        return cell
    }
}
