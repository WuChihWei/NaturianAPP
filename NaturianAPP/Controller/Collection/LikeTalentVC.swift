//
//  LikeTalentVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/15.
//

import UIKit
import Kingfisher
import FirebaseAuth
import AuthenticationServices
import Lottie

class LikeTalentVC: UIViewController {
    
    let talentManager = TalentManager()
    let userManager = UserManager()
    let subview = UIView()
    
    let closeButton = UIButton()
    let titleLB = UILabel()
    var userInfo: UserModel!
    var talentArticles: [TalentArticle] = []
    
    let userID = Auth.auth().currentUser?.uid
//        let userID = "2"
    //    let userID = "1"
    
    var userModels: UserModel!
    private var blockUserIDs: [UserModel] = []
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        setUp()
        style()
        layout()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        currentUserState()
        //        fetchBlockInfo()
        //        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: false)
    }
    
    func currentUserState() {
        
        userManager.listenUserData(userID: userID ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.userInfo = userModel
                
                for talentID in self?.userInfo.likedTalentList ?? [] {
                    
                    self?.talentArticles.removeAll()
                    
                    self?.talentManager.fetchMyLikeData(talentID: talentID) { [weak self] result in
                        
                        switch result {
                            
                        case .success(let talentModel):
                            
                            self?.talentArticles.append(talentModel)
                                                        
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                            
                        case .failure:
                            
                            print("can't fetch data")
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    @objc func removeCollection(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }
//        self.tableView.deleteRows(at: [indexPath], with: .none)

        if sender.isSelected == true {

            userManager.removeLikedTelent(uid: self.userID ?? "", talentID: self.talentArticles[indexPath.row].talentPostID ?? "") { [weak self] result in
                switch result {
                    
                case .success:

                    self?.dismiss(animated: true)
                    
                case .failure:
                    print("can't fetch data")
                    
                }
            }

        }
    }
    
    func setUp() {
        
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        
        tableView.register(LikeTalentTVCell.self, forCellReuseIdentifier: LikeTalentTVCell.identifer)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func style() {
        subview.backgroundColor = .NaturianColor.lightGray
        
        closeButton.setImage(UIImage(named: "back_gray"), for: .normal)
        
        titleLB.text = "Favorite Talent"
        titleLB.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        titleLB.textColor = .NaturianColor.navigationGray
        
        tableView.backgroundColor = .NaturianColor.lightGray
        subview.lkBorderWidth = 1
        subview.lkBorderColor = .NaturianColor.darkGray
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
    }
    
    func layout() {
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subview)
        subview.addSubview(tableView)
        view.addSubview(closeButton)
        view.addSubview(titleLB)
        
        NSLayoutConstraint.activate([
            
            subview.topAnchor.constraint(equalTo: titleLB.bottomAnchor, constant: 12),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            titleLB.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 9),
            titleLB.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: subview.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor)
        ])
    }
}

extension LikeTalentVC: UITableViewDelegate {
    
}

extension LikeTalentVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return talentArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeTalentTVCell.identifer,
                                                       for: indexPath) as? LikeTalentTVCell else { fatalError("can't find Cell") }
        cell.postImage.layoutIfNeeded()
        cell.postImage.contentMode = .scaleAspectFill
        cell.postImage.clipsToBounds = true
        
        cell.title.text = talentArticles[indexPath.row].title
        cell.categoryBTN.setTitle(talentArticles[indexPath.row].category, for: .normal)
        cell.talentDescription .text = talentArticles[indexPath.row].content
        cell.likedBtn.addTarget(self, action: #selector(removeCollection(_:)), for: .touchUpInside)
        cell.likedBtn.isSelected = true
        
        let postUrl = URL(string: talentArticles[indexPath.row].images[0])
        cell.postImage.kf.setImage(with: postUrl)
    
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
    
}
