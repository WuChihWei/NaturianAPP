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

class HomeVC: UIViewController {
    
    var talentManager = TalentManager()
    var forumManager = ForumManager()
    var db: Firestore?
    let blackView = UIView()
    
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
        
        tableView.backgroundColor = .white
        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
        blackView.backgroundColor = .NaturianColor.lightGray
    }
    
    func layout() {
        
        blackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.addSubview(blackView)

        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blackView.heightAnchor.constraint(equalToConstant: 1),
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1 } else {
                
                return 3
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0 :
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: HomeTopTVCell.identifer,
                                                        for: indexPath) as? HomeTopTVCell else { fatalError("can't find Cell") }
        
        return cell1
        
        case 1 :
            
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: HomeBottomTVCell.identifer,
                                                            for: indexPath) as? HomeBottomTVCell else { fatalError("can't find Cell") }
            
//            cell2.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
//            cell2.lkCornerRadius = 30
            cell2.backgroundColor = .white
            return cell2
            
        default:
            
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: HomeBottomTVCell.identifer,
                                                            for: indexPath) as? HomeBottomTVCell else { fatalError("can't find Cell") }
            cell2.selectionStyle = .none
//            cell2.
            return cell2
            
        }
    }
}
