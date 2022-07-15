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
import FirebaseAuth

class TalentLobbyVC: UIViewController, UITextFieldDelegate {
    
    var talentManager = TalentManager()
    var userManager = UserManager()
    var userInfo: UserModel!

    var db: Firestore?
    
    private let tableView = UITableView()
    let searchTextField = UITextField()
    let filterButton = UIButton()
    let searchBtn = UIButton()
    let userID = Auth.auth().currentUser?.uid
//    let userID = "2"
//    let userID = "1"

    let addPosteBTN = UIButton()
    let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
    let clearBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    var talentArticles: [TalentArticle] = []
    var userModels: [UserModel] = []
    let subview = UIView()
    
    let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        
        viewLayout.scrollDirection = .horizontal
        viewLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        viewLayout.minimumLineSpacing = 12
        viewLayout.itemSize = CGSize(width: 100,
                                     height: 36)
        
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var categories = [  (name: "Food", imageName: "foodDetail"),
                       (name: "Grocery", imageName: "groceryDetail"),
                       (name: "Plant", imageName:"plantDetail"),
                       (name: "Adventure", imageName: "adventureDetail"),
                       (name: "Exercise", imageName: "exerciseDetail"),
                       (name: "Treatment", imageName: "treatmentDetail") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        setUp()
        style()
        layout()
        setupViews()
//        fetchTalentArticle()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension

        tabBarController?.tabBar.isHidden = false
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupViews() {
        
        collectionView.register(CategoryFirstCVCell.self, forCellWithReuseIdentifier: CategoryFirstCVCell.identifer)
        collectionView.register(CategoryCVCell.self, forCellWithReuseIdentifier: CategoryCVCell.identifer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        tableView.layoutIfNeeded()
//        fetchTalentArticle()
        userState()
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func fetchUserBlockList() {
        
    }
    
    func userState() {
        
        userManager.fetchUserData(userID: userID ?? "" ) { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.userInfo = userModel
                
                if self?.userInfo.blockList.count == 0 {
                    
                    self?.talentManager.fetchData { [weak self] result in
                        
                        switch result {
                            
                        case .success(let talentArticles):
                            
                            self?.talentArticles = talentArticles
                            
                            self?.tableView.reloadData()
                            
                        case .failure:
                            
                            print("can't fetch data")
                        }
                    }
                    
                } else if self?.userInfo.blockList.count == 1 {
                    
                    self?.talentManager.fetch1BlockListData(blockList: self?.userInfo.blockList ?? [] ) { [weak self] result in
                        
                        switch result {
            
                        case .success(let talentArticles):
            
                            self?.talentArticles = talentArticles                            
            
                            self?.tableView.reloadData()
            
                        case .failure:
            
                            print("can't fetch data")
                        }
                    }
                    
                } else if self?.userInfo.blockList.count ?? 0 >= 2 {
                                    
                    self?.talentManager.fetchBlockListData(blockList: self?.userInfo.blockList ?? []) { [weak self] result in
                        
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
//                print(self?.userInfo ?? "")
                DispatchQueue.main.async {
                    
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    @objc func clearText() {
        searchTextField.text = ""
    }
    
    func setUp() {
        
        clearBtn.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        addPosteBTN.addTarget(self, action: #selector(postTalent), for: .touchUpInside)
        
        tableView.register(TalentLobbyTableViewCell.self, forCellReuseIdentifier: TalentLobbyTableViewCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        filterButton.addTarget(self, action: #selector(filterTalent), for: .touchUpInside)
        
        searchTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        searchTextFieldSetup()
    }
    
    @objc func postTalent() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "PostTalentVC") as? PostTalentVC else {
            
            fatalError("can't find PostTalentVC")
        }
        vc.modalPresentationStyle = .pageSheet
        self.navigationController?.present(vc, animated: false)
//        present(vc, animated: false)
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
            let filterArray = self.talentArticles.filter { (filterArray) -> Bool in
                let words = filterArray.title?.description
                let isMach = words?.localizedCaseInsensitiveContains(self.searchTextField.text ?? "")
                return isMach ?? true
            }
            self.talentArticles = filterArray
            tableView.reloadData()
        } else {
            userState()
            tableView.reloadData()
        }
    }
    
    @objc func filterTalent() {
  
        guard let talentFilterVC = storyboard?.instantiateViewController(withIdentifier: "TalentFilterVC") as? TalentFilterVC else {
            print("Can't find TalentFilterVC")
            return
        }
        present(talentFilterVC, animated: true, completion: nil)
        
        talentFilterVC.filterDelegate = self
    }
    
    func style() {
                
        clearBtn.setImage(UIImage(named: "xcircle"), for: .normal)
        searchBtn.setImage(UIImage(named: "search"), for: .normal)
        // addButton
        addPosteBTN.setImage(UIImage(named: "plus"), for: .normal)
        addPosteBTN.clipsToBounds = false
        addPosteBTN.layer.shadowOpacity = 0.3
        addPosteBTN.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        view.backgroundColor = .NaturianColor.lightGray
        view.lkBorderColor = .white
        
        // subview
//        subview.lkCornerRadius = 30
        subview.backgroundColor = .NaturianColor.lightGray
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        // searchTextField
        searchTextField.placeholder = "Search Result"
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.backgroundColor = .white
        searchTextField.addPadding(.left(35))
        searchTextField.lkCornerRadius = 20
        searchTextField.lkBorderWidth = 1
        searchTextField.lkBorderColor = .NaturianColor.darkGray

//        searchTextField.clipsToBounds = false
//        searchTextField.layer.shadowOpacity = 0.3
//        searchTextField.layer.shadowOffset = CGSize(width: 0, height: 3)
        // filterButton
        filterButton.setImage(UIImage(named: "sliders"), for: .normal)
    }
    
    func layout() {
        
//        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        addPosteBTN.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = .clear
        
        searchTextField.addSubview(searchBtn)
        view.addSubview(collectionView)
        view.addSubview(addPosteBTN)
        view.addSubview(subview)
        subview.addSubview(tableView)
//        view.addSubview(addPosteBTN)
        view.addSubview(searchTextField)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            
            searchBtn.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 10),
            searchBtn.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchBtn.heightAnchor.constraint(equalToConstant: 20),
            searchBtn.widthAnchor.constraint(equalToConstant: 20),
            
            // searchTextField
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchTextField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -8),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -72),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 40),
            
            addPosteBTN.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            addPosteBTN.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            addPosteBTN.widthAnchor.constraint(equalToConstant: 36),
            addPosteBTN.heightAnchor.constraint(equalToConstant: 36),
            
            // filterButton
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            filterButton.widthAnchor.constraint(equalToConstant: 28),
            filterButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 28),
            // tableView
            subview.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
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
        let photoUrl = URL(string: talentArticles[indexPath.row].images[0])
        
        cell.title.text = talentArticles[indexPath.row].title
        cell.categoryBTN.setTitle(String(describing: talentArticles[indexPath.row].category ?? ""), for: .normal)
        cell.seedValue.text = "\(talentArticles[indexPath.row].seedValue!)"
//        cell.talentDescription.text = talentArticles[indexPath.row].content
        cell.locationLabel.text = talentArticles[indexPath.row].location
        
        cell.postImage.kf.setImage(with: photoUrl)
        cell.providerName.text = "\(String(describing: talentArticles[indexPath.row].userInfo?.name ?? ""))"
        cell.layoutIfNeeded()
        cell.postImage.clipsToBounds = true
        cell.postImage.contentMode = .scaleAspectFill
        cell.postImage.lkCornerRadius = 20
        
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "TalentDetailViewController") as? TalentDetailViewController else {
            
            fatalError("can't find TalentDetailViewController")
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.selectedArticle = talentArticles[indexPath.row]
        vc.userModels = userInfo
    }
}

extension TalentLobbyVC: TalentFilterDelegate {
    
    func sendFilterResult(filterResult: [TalentArticle]) {
        talentArticles = filterResult
        tableView.reloadData()
    }
}

extension TalentLobbyVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 { return 1 } else {
                
                return categories.count
            }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
       
        case 0 :
            guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryFirstCVCell.identifer,
                                                                for: indexPath) as?
                    CategoryFirstCVCell else { fatalError("can't find Cell") }
            
            cell1.lkBorderColor = .clear
//            cell1.tilteLB.textColor = .clear
            cell1.backgroundColor = .clear
            return cell1
            
        case 1 :
        guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCVCell.identifer,
                                                            for: indexPath) as?
                CategoryCVCell else { fatalError("can't find Cell") }
        
        cell2.iconView.image = UIImage(named: "\(categories[indexPath.row].imageName)")
        
        cell2.tilteLB.text = categories[indexPath.row].name
        cell2.lkBorderWidth = 1
        cell2.lkCornerRadius = 18
        cell2.lkBorderColor = .NaturianColor.darkGray
        cell2.backgroundColor = .white
            
        return cell2
            
        default:
            break
        }
        return UICollectionViewCell()
    }
}

extension TalentLobbyVC: UICollectionViewDelegate {
    
}
