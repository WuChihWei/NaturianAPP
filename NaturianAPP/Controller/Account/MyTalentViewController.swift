//
//  MyTalentViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class MyTalentViewController: UIViewController {

    private let tableView = UITableView()
    
    var talentManager = TalentManager()
    var db: Firestore!

    let searchTextField = UITextField()
    let filterButton = UIButton()
    let addTalentButton = UIButton()
    var talentArticles: [TalentArticle] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        style()
        layout()
        fetchTalentArticle()
//        readData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.layoutIfNeeded()
        addTalentButton.layer.cornerRadius = (addTalentButton.bounds.width) / 2
        addTalentButton.layer.cornerRadius = (addTalentButton.bounds.width) / 2
    }

//    func readData() {
//        talentManager.readData()
//     }
    
    func fetchTalentArticle() {
        
        talentManager.fetchData { [weak self] result in

            switch result {

            case .success(let talentArticles):

                self?.talentArticles = talentArticles
                
                self?.tableView.reloadData()

            case .failure:

                print("can't fetch data")
            }
        }
        
//        talentManager.readData()
        print(LocalizedError.self)
    }
    
    func setUp() {
        
        tableView.register(MyTalentTableViewCell.self, forCellReuseIdentifier: MyTalentTableViewCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        // addButton
        addTalentButton.addTarget(self, action: #selector(postTalent), for: .touchUpInside)
    }

    func style() {
        
        tableView.separatorStyle = .none
        
        // addButton
        addTalentButton.setTitle("", for: .normal)
        addTalentButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTalentButton.backgroundColor = .systemGreen
        addTalentButton.tintColor = .white
    }

    func layout() {

        tableView.translatesAutoresizingMaskIntoConstraints = false
        addTalentButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.addSubview(addTalentButton)

        NSLayoutConstraint.activate([
            // tableView
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            // addTalentButton
            addTalentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            addTalentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addTalentButton.widthAnchor.constraint(equalToConstant: 58),
            addTalentButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    @objc func postTalent() {
        
        showPostTalentVC()
    }
    
    private func showPostTalentVC() {
        
        performSegue(withIdentifier: "ToPostTalentSegue", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToPostTalentSegue" {
//            if let toPostVC = segue.destination as? ToCommentViewController {
//                toCommentVC.userName = self.user!.name
//            }
//        }
//    }
    
}

extension MyTalentViewController: UITableViewDelegate {
    
}

extension MyTalentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talentArticles.count
        //        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTalentTableViewCell.identifer,
                                                       for: indexPath) as? MyTalentTableViewCell else {
            
            fatalError("can't find TalentLobbyTableViewCell")
            
        }
        
        cell.title.text = talentArticles[indexPath.row].title
        cell.category.text = talentArticles[indexPath.row].category
        cell.seedValue.text = talentArticles[indexPath.row].seedValue
        cell.talentDescription.text = talentArticles[indexPath.row].content
//        cell.postImage.image = talentArticles[indexPath.row]
        return cell
    }
}
