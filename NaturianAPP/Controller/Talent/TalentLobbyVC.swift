//
//  TalentViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class TalentLobbyVC: UIViewController {
   
    var talentManager = TalentManager()
    var db: Firestore?
    
    private let tableView = UITableView()
    let searchTextField = UITextField()
    let filterButton = UIButton()
    let searchBtn = UIButton()
    let cleanBtn = UIButton()

    let addPosteBTN = UIButton()

    var talentArticles: [TalentArticle] = []
    var userManager = UserManager()
    var userModels: [UserModel] = []
    let subview = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        setUp()
        style()
        layout()
        fetchTalentArticle()
        tableView.showsVerticalScrollIndicator = false

        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        tableView.layoutIfNeeded()
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
        
        addPosteBTN.addTarget(self, action: #selector(postTalent), for: .touchUpInside)
        
        tableView.register(TalentLobbyTableViewCell.self, forCellReuseIdentifier: TalentLobbyTableViewCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        filterButton.addTarget(self, action: #selector(filterTalent), for: .touchUpInside)
    }
    
    @objc func postTalent() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "PostTalentVC") as? PostTalentVC else {
            
            fatalError("can't find PostTalentVC")
        }
                self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true)
    }
    
    private func showPostTalentVC() {
        
    }
    
    @objc func filterTalent() {
//        performSegue(withIdentifier: "filterTalentSegue", sender: nil)
        guard let talentFilterVC = storyboard?.instantiateViewController(withIdentifier: "TalentFilterVC") as? TalentFilterVC else {
            print("Can't find TalentFilterVC")
            return
        }
        talentFilterVC.modalPresentationStyle = .overFullScreen
        present(talentFilterVC, animated: true, completion: nil)
        
        talentFilterVC.filterDelegate = self
    }
    
    func style() {
        
        searchBtn.setImage(UIImage(named: "search"), for: .normal)
        // addButton
        addPosteBTN.setTitle("Post", for: .normal)
        addPosteBTN.backgroundColor = .NaturianColor.darkGray
        addPosteBTN.tintColor = .white
        addPosteBTN.setTitleColor(.white, for: .normal)
        addPosteBTN.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        addPosteBTN.lkCornerRadius = 16
        
        view.backgroundColor = .NaturianColor.navigationGray
        view.lkBorderColor = .white
       
        // subview
        subview.lkCornerRadius = 30
        subview.backgroundColor = .NaturianColor.lightGray

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        // searchTextField
        searchTextField.placeholder = "Search Result"
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.backgroundColor = .white
        searchTextField.addPadding(.left(30))
        searchTextField.lkCornerRadius = 20
        // filterButton
        filterButton.setImage(UIImage(named: "sliders"), for: .normal)
    }
    
    func layout() {
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        addPosteBTN.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.addSubview(searchBtn)
        view.addSubview(subview)
        subview.addSubview(tableView)
        view.addSubview(addPosteBTN)
        view.addSubview(searchTextField)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            
            searchBtn.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 10),
            searchBtn.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchBtn.heightAnchor.constraint(equalToConstant: 18),
            searchBtn.widthAnchor.constraint(equalToConstant: 18),

            // searchTextField
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addPosteBTN.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor),
            addPosteBTN.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            addPosteBTN.widthAnchor.constraint(equalToConstant: 128),
            addPosteBTN.heightAnchor.constraint(equalToConstant: 32),
            
            // filterButton
            filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            filterButton.widthAnchor.constraint(equalToConstant: 28),
            filterButton.heightAnchor.constraint(equalToConstant: 28),
            // tableView
            subview.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 16),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            
            tableView.topAnchor.constraint(equalTo: subview.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0)
            
            // addTalentButton
          
        ])
    }
}

extension TalentLobbyVC: UITableViewDelegate {
    
}

extension TalentLobbyVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talentArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TalentLobbyTableViewCell.identifer,
                                                       for: indexPath) as? TalentLobbyTableViewCell else {
            
            fatalError("can't find TalentLobbyTableViewCell")
        }
        let photoUrl = talentArticles[indexPath.row].images[0]
        
        cell.title.text = talentArticles[indexPath.row].title
        cell.categoryBTN.setTitle(String(describing: talentArticles[indexPath.row].category ?? ""), for: .normal)
        cell.seedValue.text = "\(talentArticles[indexPath.row].seedValue!)"
        cell.talentDescription.text = talentArticles[indexPath.row].content
        cell.locationLabel.text = talentArticles[indexPath.row].location
        cell.postImage.kf.setImage(with: photoUrl)
        cell.providerName.text = talentArticles[indexPath.row].userInfo?.name
        cell.layoutIfNeeded()
        cell.postImage.clipsToBounds = true
        cell.postImage.contentMode = .scaleAspectFill
        
        switch talentArticles[indexPath.row].userInfo?.gender {
            
        case "Male":
            cell.genderIcon.image = UIImage(named: "male")
        case "Female":
            cell.genderIcon.image = UIImage(named: "female")
        case "Undefined":
            cell.genderIcon.image = UIImage(named: "undefined")
        default:
            break
        }
        
        switch talentArticles[indexPath.row].category {
            
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
            withIdentifier: "TalentDetailViewController") as? TalentDetailViewController else {
            
            fatalError("can't find TalentDetailViewController")
        }
        self.navigationController?.pushViewController(vc, animated: true)
    
        vc.selectedArticle = talentArticles[indexPath.row]
    }
}

extension TalentLobbyVC: TalentFilterDelegate {
    
    func sendFilterResult(filterResult: [TalentArticle]) {
        talentArticles = filterResult
        tableView.reloadData()
    }
}
