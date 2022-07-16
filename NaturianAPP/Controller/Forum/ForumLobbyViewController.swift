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
import FirebaseAuth

class ForumLobbyViewController: UIViewController, UITextFieldDelegate {
    
    var forumManager = ForumManager()
    let talentManager = TalentManager()
    let userManager = UserManager()
    var db: Firestore?
    let userID = Auth.auth().currentUser?.uid
    var userInfo: UserModel!
    let searchBtn = UIButton()
    let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
    let clearBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))

    private let tableView = UITableView()
    
    let addArticleBTN = UIButton()
    let titleLB = UILabel()
    let closeButton = UIButton()
    let searchTextField = UITextField()
    let subview = UIView()
    
    var forumArticles: [ForumModel] = []
    //    var talentArticles: [TalentArticle] = []
    var userModels: [UserModel] = []
    var likeForums: [UserModel] = []
    var likeSeeds: [UserModel] = []

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
        currentUserState()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func currentUserState() {
        
        userManager.listenUserData(userID: userID ?? "") { [weak self] result in
                
                switch result {

                case .success(let userModel):

                    self?.userInfo = userModel
                    
                    print(self?.userModels ?? "")
                    DispatchQueue.main.async {
                        
                        self?.viewDidLoad()
                    }
                    
                case .failure:
                    print("can't fetch data")
                }
            }
        }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func clearText() {
        searchTextField.text = ""
    }
    
    @objc func postArticle() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "PostArticleViewController") as? PostArticleViewController else {
            
            fatalError("can't find PostArticleViewController")
        }
        present(vc, animated: true)
    }
    
    func fetchForumArticle() {
        
        print(forumArticles)
        
        forumManager.fetchCategoryData(category: forumTitle) { [weak self] result in
            
            switch result {
                
            case .success(let forumArticles):
                
                self?.forumArticles = forumArticles
                
//                for forumArticle in self?.forumArticles ?? [] {
//                    self?.userManager.fetchForumLikeCount(forumID: forumArticle.postArticleID ?? "") { [weak self] result in
//
//                        switch result {
//
//                        case .success(let userModels):
//
//                            self?.likeForums = userModels
//
//                            self?.tableView.reloadData()
//
//                        case .failure:
//
//                            print("can't fetch data")
//                        }
//                    }
//                }
//
//                for forumArticle in self?.forumArticles ?? [] {
//                    self?.userManager.fetchForumSeedCount(forumID: forumArticle.postArticleID ?? "") { [weak self] result in
//
//                        switch result {
//
//                        case .success(let userModels):
//
//                            self?.likeSeeds = userModels
//
//                            self?.tableView.reloadData()
//
//                        case .failure:
//
//                            print("can't fetch data")
//                        }
//                    }
//                }
                
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
        searchTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        searchTextFieldSetup()
    }
    
    func searchTextFieldSetup() {
        searchTextField.delegate = self
        searchTextField.rightView = outerView
//        outerView.backgroundColor = .blue
        
        outerView.addSubview(clearBtn)
        
        searchTextField.rightViewMode = .whileEditing
        searchTextField.rightView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if searchTextField.text != "" {
            let filterArray = self.forumArticles.filter { (filterArray) -> Bool in
                let words = filterArray.title?.description
                let isMach = words?.localizedCaseInsensitiveContains(self.searchTextField.text ?? "")
                return isMach ?? true
            }
            self.forumArticles = filterArray
            tableView.reloadData()
        } else {
            fetchForumArticle()
            tableView.reloadData()
        }
    }
    
    func style() {
        
//        switch forumTitle {
//
//        case "Food":
//            addArticleBTN.backgroundColor = .NaturianColor.foodYellow
//            view.backgroundColor = .NaturianColor.foodYellow
//
//        case "Plant":
//            addArticleBTN.backgroundColor = .NaturianColor.plantGreen
//            view.backgroundColor = .NaturianColor.plantGreen
//
//        case "Adventure":
//            addArticleBTN.backgroundColor = .NaturianColor.adventurePink
//            view.backgroundColor = .NaturianColor.adventurePink
//
//        case "Grocery":
//            addArticleBTN.backgroundColor = .NaturianColor.groceryBlue
//            view.backgroundColor = .NaturianColor.groceryBlue
//
//        case "Exercise":
//            addArticleBTN.backgroundColor = .NaturianColor.exerciseBlue
//            view.backgroundColor = .NaturianColor.exerciseBlue
//
//        case "Treatment":
//            addArticleBTN.backgroundColor = .NaturianColor.treatmentGreen
//            view.backgroundColor = .NaturianColor.treatmentGreen
//
//        default:
//            break
//
//        }
        view.backgroundColor =  .NaturianColor.lightGray
        clearBtn.setImage(UIImage(named: "xcircle"), for: .normal)
        searchBtn.setImage(UIImage(named: "search"), for: .normal)
        // addButton
        addArticleBTN.setImage(UIImage(systemName: "plus"), for: .normal)
//        addArticleBTN.backgroundColor = .NaturianColor.treatmentGreen
        addArticleBTN.tintColor = .white
        addArticleBTN.backgroundColor = .NaturianColor.treatmentGreen
        addArticleBTN.lkCornerRadius = 20
        
        view.lkBorderColor = .NaturianColor.lightGray
        // close button
        closeButton.setImage(UIImage(named: "backNoCircle"), for: .normal)
        
        titleLB.font = UIFont(name: Roboto.bold.rawValue, size: 24)
        titleLB.textColor = .NaturianColor.darkGray
        titleLB.text = "/ \(forumTitle) /"
        // subview
        subview.backgroundColor = .NaturianColor.lightGray

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        // searchTextField
        searchTextField.placeholder = "Search Result"
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.backgroundColor = .white
        searchTextField.addPadding(.left(35))
        searchTextField.lkCornerRadius = 20
//        searchTextField.lkBorderWidth = 1
//        searchTextField.lkBorderColor = .NaturianColor.darkGray
        
    }
    
    func layout() {
        addArticleBTN.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLB)
        view.addSubview(closeButton)
        
        searchTextField.addSubview(searchBtn)
        view.addSubview(subview)
        subview.addSubview(tableView)
        view.addSubview(addArticleBTN)
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            
            searchBtn.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 10),
            searchBtn.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchBtn.heightAnchor.constraint(equalToConstant: 20),
            searchBtn.widthAnchor.constraint(equalToConstant: 20),
            
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
            searchTextField.trailingAnchor.constraint(equalTo: addArticleBTN.leadingAnchor, constant: -18),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
 
            // tableView
            subview.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            
            tableView.topAnchor.constraint(equalTo: subview.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0),
            
            // addTalentButton
            addArticleBTN.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            addArticleBTN.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            addArticleBTN.widthAnchor.constraint(equalToConstant: 40),
            addArticleBTN.heightAnchor.constraint(equalToConstant: 40)
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
//        cell.
        let photoUrl = forumArticles[indexPath.row].images[0]
        cell.postImage.kf.setImage(with: photoUrl)
        
        cell.likeLB.text = String(describing: forumArticles[indexPath.row].getLikedValue ?? 0)
        cell.seedLB.text = String(describing: forumArticles[indexPath.row].getSeedValue ?? 0)

        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.lkCornerRadius = 15

        switch forumArticles[indexPath.row].category {
            
        case "Food":
            cell.categoryBTN.backgroundColor = .NaturianColor.foodYellow

        case "Plant":
            cell.categoryBTN.backgroundColor = .NaturianColor.plantGreen

        case "Adventure":
            cell.categoryBTN.backgroundColor = .NaturianColor.adventurePink

        case "Grocery":
            cell.categoryBTN.backgroundColor = .NaturianColor.groceryBlue

        case "Exercise":
            cell.categoryBTN.backgroundColor = .NaturianColor.exerciseBlue

        case "Treatment":
            cell.categoryBTN.backgroundColor = .NaturianColor.treatmentGreen

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
        vc.userInfo = self.userInfo
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
