//
//  ForumLobbyVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import SwiftUI

class ForumLobbyViewController: UIViewController {
   
    var talentManager = TalentManager()
    var db: Firestore?
    
    private let tableView = UITableView()
    let searchTextField = UITextField()
    let filterButton = UIButton()
    let subview = UIView()
    
    var talentArticles: [TalentArticle] = []
    var userManager = UserManager()
    var userModels: [UserModel] = []
    var talentArticle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        fetchTalentArticle()
        
        tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        fetchTalentArticle()
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func fetchTalentArticle() {
        
        print(talentArticles)
        
        talentManager.fetchData { [weak self] result in
            
            switch result {
                
            case .success(let talentArticles):
                
                self?.talentArticles = talentArticles
                
                self?.tableView.reloadData()
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
    
    func setUp() {
        
        tableView.register(ForumLobbyTableViewCell.self, forCellReuseIdentifier: ForumLobbyTableViewCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension

    }
    
    func style() {
        
        view.lkBorderColor = .white
        subview.backgroundColor = .NaturianColor.lightGray
        subview.lkCornerRadius = 30
        // backTabBar
        let barButton = UIBarButtonItem()
        barButton.title = ""
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        view.backgroundColor = .NaturianColor.navigationGray
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        // searchTextField
        searchTextField.placeholder = "Search Result"
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.backgroundColor = .white
        searchTextField.addPadding(.left(24))
        searchTextField.lkCornerRadius = 20
        searchTextField.lkBorderWidth = 1
        // filterButton
        filterButton.setImage(UIImage(named: "sliders"), for: .normal)
        filterButton.setTitle("", for: .normal)
    }
    
    func layout() {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subview)
        subview.addSubview(tableView)
        view.addSubview(searchTextField)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            
            // tableView
            subview.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 16),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: subview.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0),
            // searchTextField
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            // filterButton
            filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            filterButton.widthAnchor.constraint(equalToConstant: 28),
            filterButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}

extension ForumLobbyViewController: UITableViewDelegate {
    
}

extension ForumLobbyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return talentArticles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        175
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForumLobbyTableViewCell.identifer,
                                                       for: indexPath) as? ForumLobbyTableViewCell else {
            
            fatalError("can't find ForumLobbyTableViewCell")
        }
        let photoUrl = talentArticles[indexPath.section].images[0]
        cell.selectionStyle = .none
        
        cell.title.text = talentArticles[indexPath.section].title
        cell.category.text = talentArticles[indexPath.section].category
        cell.seedValue.text = "\(talentArticles[indexPath.section].seedValue!)"
        cell.talentDescription.text = talentArticles[indexPath.section].content
        cell.locationLabel.text = talentArticles[indexPath.section].location
        cell.postImage.kf.setImage(with: photoUrl)
        cell.providerName.text = talentArticles[indexPath.section].userInfo?.name
        cell.layoutIfNeeded()
        cell.postImage.clipsToBounds = true
        cell.postImage.contentMode = .scaleAspectFill
        
        cell.layoutIfNeeded()
        cell.backgroundColor = .white
        cell.lkCornerRadius = 15
//        cell.lkBorderColor = .NaturianColor.navigationGray
//        cell.lkBorderWidth = 1
        
        if talentArticles[indexPath.row].userInfo?.gender == "Male" {
            
            cell.genderIcon.image = UIImage(named: "heart")
            
        } else if talentArticles[indexPath.row].userInfo?.gender == "Female" {
            
            cell.genderIcon.image = UIImage(named: "female")
            
        } else {
            
            cell.genderIcon.image = UIImage(named: "undefined")
        }
        
        return cell
    }
    
}
