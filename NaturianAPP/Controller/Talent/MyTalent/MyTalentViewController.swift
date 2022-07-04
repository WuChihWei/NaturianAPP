//
//  MyTalentViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import FirebaseAuth

class MyTalentViewController: UIViewController {

    private let tableView = UITableView()
    
    var talentManager = TalentManager()
    var userManager = UserManager()

    var db: Firestore!
//    let userID = Auth.auth().currentUser?.uid
    let userID = "2"

    let searchTextField = UITextField()
    let filterButton = UIButton()
    let addTalentButton = UIButton()
    let subview = UIView()

    var talentArticles: [TalentArticle] = []
    var didSeletectApplierIDs: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        style()
        layout()
        fetchMyTalentArticle()
//        readData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchMyTalentArticle()
//        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        tableView.layoutIfNeeded()
        addTalentButton.layer.cornerRadius = (addTalentButton.bounds.width) / 2
    }
    
        func fetchMyTalentArticle() {
    
            talentManager.fetchMyIDData(userID: userID ?? "") { [weak self] result in
    
                switch result {
    
                case .success(let talentArticles):
    
                    self?.talentArticles = talentArticles
    
                    self?.tableView.reloadData()
    
                case .failure:
    
                    print("can't fetch data")
                }
            }
    
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
        
        subview.backgroundColor = .NaturianColor.lightGray
       
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        // addButton
        addTalentButton.setTitle("", for: .normal)
        addTalentButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTalentButton.backgroundColor = .systemGreen
        addTalentButton.tintColor = .white
    }

    func layout() {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addTalentButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subview)
        subview.addSubview(tableView)
        tableView.addSubview(addTalentButton)

        NSLayoutConstraint.activate([
            
            subview.topAnchor.constraint(equalTo: view.topAnchor),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: subview.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0),
            
            // addTalentButton
            addTalentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26),
            addTalentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
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
}

extension MyTalentViewController: UITableViewDelegate {
    
}

extension MyTalentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talentArticles.count
        //        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell( withIdentifier: MyTalentTableViewCell.identifer,
            for: indexPath) as? MyTalentTableViewCell else {
            
            fatalError("can't find TalentLobbyTableViewCell")
            
        }

        cell.title.text = talentArticles[indexPath.row].title
        cell.categoryBTN.setTitle("\(talentArticles[indexPath.row].category ?? "")", for: .normal)
        cell.seedValue.text = "\(talentArticles[indexPath.row].seedValue ?? 0)"
        cell.talentDescription.text = talentArticles[indexPath.row].content
        cell.postImage.kf.setImage(with: talentArticles[indexPath.row].images[0])
        cell.messageAmountButton.setTitle("+\(talentArticles[indexPath.row].didApplyID.count - 1)", for: .normal)
        
//        cell.postImage.image = talentArticles[indexPath.row]
        
        cell.layoutIfNeeded()
        cell.postImage.clipsToBounds = true
        cell.postImage.contentMode = .scaleAspectFill

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "MyTalentAppliersVC") as? MyTalentAppliersVC else {

            fatalError("can't find MyTalentDetailVC")
        }
        
        vc.talentArticleID = talentArticles[indexPath.row].talentPostID
        
        self.navigationController?.pushViewController(vc, animated: true)
//
//        for item in 0..<talentArticles[indexPath.row].didApplyID.count {
//            let test = talentArticles[indexPath.row].didApplyID[item]
//            let test2 = test
//            print(test2)
//            didSeletectApplierIDs.append(test)
//
//        }
        
        didSeletectApplierIDs = talentArticles[indexPath.row].didApplyID
        vc.didSeletectApplierIDs = didSeletectApplierIDs
        
    }
}
