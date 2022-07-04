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
    
    var forumManager = ForumManager()
    var talentManager = TalentManager()
    var db: Firestore?
    
    private let tableView = UITableView()
    
    let addArticleBTN = UIButton()
    let titleLB = UILabel()
    let closeButton = UIButton()
    let searchTextField = UITextField()
    let filterButton = UIButton()
    let subview = UIView()
    
    var forumArticles: [ForumModel] = []
    //    var talentArticles: [TalentArticle] = []
    var userManager = UserManager()
    var userModels: [UserModel] = []
    //    var talentArticle: String = ""
    var searchController: UISearchController!
    var forumTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        fetchForumArticle()
        
        tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        addArticleBTN.layer.cornerRadius = (addArticleBTN.bounds.width) / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        fetchForumArticle()
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func postArticle() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "PostArticleViewController") as? PostArticleViewController else {
            
            fatalError("can't find PostArticleViewController")
        }
        
        //        self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    
    func fetchForumArticle() {
        
        print(forumArticles)
        
        forumManager.fetchCategoryData(category: forumTitle) { [weak self] result in
            
            switch result {
                
            case .success(let forumArticles):
                
                self?.forumArticles = forumArticles
                
                self?.tableView.reloadData()
                
                print(self?.forumArticles ?? [])
                
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
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        
        addArticleBTN.addTarget(self, action: #selector(postArticle), for: .touchUpInside)
    }
    
    func style() {
        
        switch forumTitle {

        case "Food":
            addArticleBTN.backgroundColor = .NaturianColor.foodYellow
//            view.backgroundColor = .NaturianColor.foodOrange

        case "Plant":
            addArticleBTN.backgroundColor = .NaturianColor.plantGreen
//            view.backgroundColor = .NaturianColor.plantGreen

        case "Adventure":
            addArticleBTN.backgroundColor = .NaturianColor.adventurePink
//            view.backgroundColor = .NaturianColor.adventureBlue

        case "Grocery":
            addArticleBTN.backgroundColor = .NaturianColor.groceryBlue
//            view.backgroundColor = .NaturianColor.groceryYellow

        case "Exercise":
            addArticleBTN.backgroundColor = .NaturianColor.exerciseBlue
//            view.backgroundColor = .NaturianColor.exerciseGreen

        case "Treatment":
            addArticleBTN.backgroundColor = .NaturianColor.treatmentGreen
//            view.backgroundColor = .NaturianColor.treatmentGreen

        default:
            break

        }
        
        // addButton
        addArticleBTN.setTitle("", for: .normal)
        addArticleBTN.setImage(UIImage(systemName: "plus"), for: .normal)
//        addArticleBTN.backgroundColor = .NaturianColor.groceryYellow
        addArticleBTN.tintColor = .white
        
        view.backgroundColor = .NaturianColor.navigationGray
        view.lkBorderColor = .white
        // close button
        closeButton.setImage(UIImage(named: "backNoCircle"), for: .normal)
        
        titleLB.font = UIFont(name: Roboto.black.rawValue, size: 32)
        titleLB.textColor = .white
        titleLB.text = "/ \(forumTitle) /"
        // subview
        subview.lkCornerRadius = 30
        subview.backgroundColor = .NaturianColor.lightGray

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        // searchTextField
        searchTextField.placeholder = "Search Result"
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.backgroundColor = .white
        searchTextField.addPadding(.left(24))
        searchTextField.lkCornerRadius = 12
        // filterButton
        filterButton.setImage(UIImage(named: "searchByTime"), for: .normal)
        
    }
    
    func layout() {
        addArticleBTN.translatesAutoresizingMaskIntoConstraints = false
        
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLB)
        view.addSubview(closeButton)
        
        view.addSubview(subview)
        subview.addSubview(tableView)
        tableView.addSubview(addArticleBTN)
        view.addSubview(searchTextField)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            
            closeButton.centerYAnchor.constraint(equalTo: titleLB.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 17),
            closeButton.widthAnchor.constraint(equalToConstant: 17),
            
            titleLB.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLB.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLB.heightAnchor.constraint(equalToConstant: 32),
            
            // searchTextField
            searchTextField.topAnchor.constraint(equalTo: titleLB.bottomAnchor, constant: 12),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchTextField.trailingAnchor.constraint(equalTo: titleLB.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            // filterButton
            filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            filterButton.widthAnchor.constraint(equalToConstant: 28),
            filterButton.heightAnchor.constraint(equalToConstant: 28),
            // tableView
            subview.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 12),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            
            tableView.topAnchor.constraint(equalTo: subview.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0),
            
            // addTalentButton
            addArticleBTN.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            addArticleBTN.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            addArticleBTN.widthAnchor.constraint(equalToConstant: 58),
            addArticleBTN.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}

extension ForumLobbyViewController: UITableViewDelegate {
    
}

extension ForumLobbyViewController: UITableViewDataSource {
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return talentArticles.count
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumArticles.count
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        10
    //    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //            let headerView = UIView()
    //            headerView.backgroundColor = UIColor.clear
    //            return headerView
    //        }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        175
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForumLobbyTableViewCell.identifer,
                                                       for: indexPath) as? ForumLobbyTableViewCell else {
            
            fatalError("can't find ForumLobbyTableViewCell")
        }
        cell.layoutIfNeeded()
        cell.postImage.clipsToBounds = true
        cell.postImage.contentMode = .scaleAspectFill
        
        cell.title.text = forumArticles[indexPath.row].title
        cell.categoryBTN.setTitle(forumArticles[indexPath.row].category, for: .normal)
        cell.articleContent.text = forumArticles[indexPath.row].content
        cell.likeLB.text = String(describing: forumArticles[indexPath.row].getLikedValue!)
        cell.seedLB.text = String(describing: forumArticles[indexPath.row].getSeedValue!)
                
        let photoUrl = forumArticles[indexPath.row].images[0]
        cell.postImage.kf.setImage(with: photoUrl)
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.lkCornerRadius = 15
        //        cell.seedValue.text = "\(talentArticles[indexPath.section].seedValue!)"
        //        cell.locationLabel.text = talentArticles[indexPath.section].location
        //        cell.providerName.text = talentArticles[indexPath.section].userInfo?.name
     
        //        cell.lkBorderColor = .NaturianColor.navigationGray
        //        cell.lkBorderWidth = 1

        switch forumArticles[indexPath.row].category {
            
        case "Food":
            cell.categoryBTN.backgroundColor = .NaturianColor.foodYellow
            addArticleBTN.backgroundColor = .NaturianColor.foodYellow
            
        case "Plant":
            cell.categoryBTN.backgroundColor = .NaturianColor.plantGreen
            addArticleBTN.backgroundColor = .NaturianColor.plantGreen

        case "Adventure":
            cell.categoryBTN.backgroundColor = .NaturianColor.adventurePink
            addArticleBTN.backgroundColor = .NaturianColor.adventurePink

        case "Grocery":
            cell.categoryBTN.backgroundColor = .NaturianColor.groceryBlue
            addArticleBTN.backgroundColor = .NaturianColor.groceryBlue

        case "Exercise":
            cell.categoryBTN.backgroundColor = .NaturianColor.exerciseBlue
            addArticleBTN.backgroundColor = .NaturianColor.exerciseBlue

        case "Treatment":
            cell.categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
            addArticleBTN.backgroundColor = .NaturianColor.treatmentGreen

        default:
            break
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ForumDetailViewController") as? ForumDetailViewController else {
            
            fatalError("can't find ForumDetailViewController")
        }
        vc.forumArticles = forumArticles[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
