//
//  TalentViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class TalentViewController: UIViewController {
    
    var talentManager = TalentManager()
    var db: Firestore?
    
    private let tableView = UITableView()
    let searchTextField = UITextField()
    let filterButton = UIButton()
    var talentArticles: [TalentArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        fetchTalentArticle()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func fetchTalentArticle() {
        
        talentManager.fetchData { [weak self] result in

            switch result {

            case .success(let talentArticles):

                self?.talentArticles = talentArticles
                
                self?.tableView.reloadData()

            case .failure:

                print("can't fetch data")
            }
        }
        
//        talentManager.readData()
        print(LocalizedError.self)
    }
    
    func setUp() {
        
        tableView.register(TalentLobbyTableViewCell.self, forCellReuseIdentifier: TalentLobbyTableViewCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }

    func style() {
        
        // backTabBar
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        tableView.separatorStyle = .none
        // searchTextField
        searchTextField.placeholder = "Search Result"
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.backgroundColor = .white
        searchTextField.addPadding(.left(24))
        searchTextField.lkCornerRadius = 20
        searchTextField.lkBorderWidth = 1
        searchTextField.lkBorderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        // filterButton
        filterButton.setImage(UIImage(named: "sliders"), for: .normal)
        filterButton.setTitle("", for: .normal)
    }

    func layout() {

        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(searchTextField)
        view.addSubview(filterButton)

        NSLayoutConstraint.activate([
            // tableView
            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            // searchTextField
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            // filterButton
            filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            filterButton.widthAnchor.constraint(equalToConstant: 28),
            filterButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}

extension TalentViewController: UITableViewDelegate {
    
}

extension TalentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talentArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TalentLobbyTableViewCell.identifer,
                                                       for: indexPath) as? TalentLobbyTableViewCell else {
            
            fatalError("can't find TalentLobbyTableViewCell")
        }
        
        cell.title.text = talentArticles[indexPath.row].title
        cell.category.text = talentArticles[indexPath.row].category
        cell.seedValue.text = talentArticles[indexPath.row].seedValue
        cell.talentDescription.text = talentArticles[indexPath.row].content
//        cell.providerName.text = talentArticles[indexPath.row].
        
        return cell
    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
