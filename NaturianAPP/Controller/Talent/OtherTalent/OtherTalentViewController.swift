//
//  OtherTalentViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import UIKit

class OtherTalentViewController: UIViewController {
    
    private let tableView = UITableView()
    
    var talentManager = TalentManager()
    var didSeletectDetails: TalentArticle!
    var userManager = UserManager()
    
    var appliedTalents: [TalentArticle] = []
    //    var didSeletectApplierIDs: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        fetchAppliedTalent()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAppliedTalent()
        tableView.reloadData()
    }
    
    func setUp() {
        
        tableView.register(OtherTalentTableViewCell.self, forCellReuseIdentifier: OtherTalentTableViewCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func style() {
        tableView.separatorStyle = .none
    }
    
    func layout() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // tableView
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    func fetchAppliedTalent() {
        
        talentManager.fetchAppliedTalent(userID: "123") { [weak self] result in
            
            switch result {
                
            case .success(let talentArticles):
                
                self?.appliedTalents = talentArticles
                
                self?.tableView.reloadData()
                
                print("+++++++++++++++++=\(self?.appliedTalents)")
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
}

extension OtherTalentViewController: UITableViewDelegate {
    
}

extension OtherTalentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appliedTalents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherTalentTableViewCell.identifer,
                                                       for: indexPath) as? OtherTalentTableViewCell else {
            
            fatalError("can't find MyTalentAppliersTableViewCell")
            
        }
        
        cell.userName.text = appliedTalents[indexPath.row].title
        return cell
    }
}
