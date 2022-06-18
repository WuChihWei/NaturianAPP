//
//  OthersTalentViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit

class OthersTalentViewController: UIViewController {
    
    private let tableView = UITableView()
    
    let searchTextField = UITextField()
    let filterButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        style()
        layout()
    }

    func setUp() {
        
        tableView.register(OthersTalentTableViewCell.self, forCellReuseIdentifier: OthersTalentTableViewCell.identifer)
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
}

extension OthersTalentViewController: UITableViewDelegate {
    
}

extension OthersTalentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OthersTalentTableViewCell.identifer,
                                                       for: indexPath) as? OthersTalentTableViewCell else {
            
            fatalError("can't find TalentLobbyTableViewCell")
        }
        return cell
    }
}
