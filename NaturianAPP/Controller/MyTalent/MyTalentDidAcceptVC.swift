//
//  MyTalentDetailVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/19.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class MyTalentDidAcceptVC: UIViewController {
    
    var didSeletectDetails: TalentArticle!
    
    private let tableView = UITableView()
    var talentManager = TalentManager()

    let filterButton = UIButton()
    let addTalentButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        style()
        layout()
    }
    
    func setUp() {
        
        tableView.register(MyTalentTableViewCell.self, forCellReuseIdentifier: MyTalentTableViewCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
    }

    func style() {
        
        tableView.separatorStyle = .none
        
        // addButton
        addTalentButton.setTitle("", for: .normal)
        addTalentButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTalentButton.backgroundColor = .systemGreen
        addTalentButton.tintColor = .white
    }

    func layout() {

        tableView.translatesAutoresizingMaskIntoConstraints = false
        addTalentButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.addSubview(addTalentButton)

        NSLayoutConstraint.activate([
            // tableView
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            // addTalentButton
            addTalentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            addTalentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addTalentButton.widthAnchor.constraint(equalToConstant: 58),
            addTalentButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

}

extension MyTalentDidAcceptVC: UITableViewDelegate {
    
}

extension MyTalentDidAcceptVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTalentTableViewCell.identifer,
                                                       for: indexPath) as? MyTalentTableViewCell else {
            
            fatalError("can't find TalentLobbyTableViewCell")
        }
//cell.userName.text = didSeletectDetails.appliers[0].applierID
        return cell
    }
}
