//
//  HomeVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/6.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

//class HomeVC: UIViewController {
//
//    private var categories = [ (name: "Food", imageName: "food_icon"),
//                               (name: "Grocery", imageName: "grocery_icon"),
//                               (name: "Plant", imageName:"plant_icon"),
//                               (name: "Adventure", imageName: "adventure_icon"),
//                               (name: "Exercise", imageName: "exercise_icon"),
//                               (name: "Treatment", imageName: "treatment_icon") ]
//
//    let firstLB = UILabel()
//    let secondLB = UILabel()
//    let thirdtLB = UILabel()
//    let titleStack = UIStackView()
//    let contentView = UIView()
//
//    let collectionView: UICollectionView = {
//        let viewLayout = HomeCVFlowLayout()
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .clear
//        return collectionView
//    }()
//
//    let seedButton = UIButton()
//    let myTalentButton = UIButton()
//    let collectionButton = UIButton()
//    let massageButton = UIButton()
//
//    let articleTableView = UITableView()
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        super.viewWillAppear(animated)
//        tabBarController?.tabBar.isHidden = false
//        self.collectionView.showsHorizontalScrollIndicator = false
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let layoutMargins: CGFloat = self.collectionView.layoutMargins.left + self.collectionView.layoutMargins.right
//        let sideInset = (self.view.frame.width / 2) - layoutMargins
//        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.isPagingEnabled = false
//        navigationController?.navigationBar.isHidden = true
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.reloadData()
//
//        setupViews()
//        setupLayouts()
//        style()
//    }
//}
//
//extension HomeVC: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVCell.identifer, for: indexPath) as?
//                HomeCVCell else { fatalError("can't find Cell") }
//
//        cell.lkCornerRadius = 15
////        cell.tilteLB.text = categories[indexPath.row].name
//        cell.cardview.image = UIImage(named: "\(categories[indexPath.row].imageName)")
//        cell.backgroundColor = .white
//        return cell
//    }
//}
//
//extension HomeVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        guard let vc = storyboard?.instantiateViewController(
//            withIdentifier: "ForumLobbyViewController") as? ForumLobbyViewController else {
//
//            fatalError("can't find ForumLobbyViewController")
//        }
//        vc.forumTitle = categories[indexPath.row].name
//
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//extension HomeVC {
//
//    private func setupViews() {
//
//        view.addSubview(titleStack)
//        view.addSubview(collectionView)
//
//        collectionView.register(HomeCVCell.self, forCellWithReuseIdentifier: HomeCVCell.identifer)
//    }
//
//    private func style() {
//
//        collectionView.backgroundColor = .clear
//        view.backgroundColor = .NaturianColor.navigationGray
//
//        firstLB.text = "Discover"
//        firstLB.textColor = .white
//        firstLB.font = UIFont(name: Roboto.black.rawValue, size: 37)
//        firstLB.numberOfLines = 0
//
//        secondLB.text = "Your Own"
//        secondLB.textColor = .white
//        secondLB.font = UIFont(name: Roboto.black.rawValue, size: 37)
//        secondLB.numberOfLines = 0
//
//        thirdtLB.text = "Universe"
//        thirdtLB.textColor = .white
//        thirdtLB.font = UIFont(name: Roboto.black.rawValue, size: 37)
//        thirdtLB.numberOfLines = 0
//
//        titleStack.axis = .vertical
//        titleStack.alignment = .leading
//        titleStack.spacing = 0.8
//    }
//
//    private func setupLayouts() {
//
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
//
//        titleStack.addArrangedSubview(firstLB)
//        titleStack.addArrangedSubview(secondLB)
//        titleStack.addArrangedSubview(thirdtLB)
//
//        titleStack.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//
//            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            titleStack.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 24),
//            titleStack.heightAnchor.constraint(equalToConstant: 120),
//            firstLB.heightAnchor.constraint(equalToConstant: 37),
//            secondLB.heightAnchor.constraint(equalToConstant: 37),
//            thirdtLB.heightAnchor.constraint(equalToConstant: 37),
//
//            collectionView.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 10),
//            collectionView.heightAnchor.constraint(equalToConstant: 270),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//        ])
//    }
//}
//

class HomeVC: UIViewController {
    
    var talentManager = TalentManager()
    var forumManager = ForumManager()
    var db: Firestore?
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        
        tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        tableView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func setUp() {
        
        tableView.register(HomeTopTVCell.self, forCellReuseIdentifier: HomeTopTVCell.identifer)
        
        tableView.register(HomeBottomTVCell.self, forCellReuseIdentifier: HomeBottomTVCell.identifer)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func style() {
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        // tableView.bounces = false
    }
    
    func layout() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
    }
}

extension HomeVC: UITableViewDelegate {
    
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1 } else {
                
                return 1
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: HomeTopTVCell.identifer,
                                                        for: indexPath) as? HomeTopTVCell else { fatalError("can't find Cell") }
        
        return cell1
        
        
    }
}
