//
//  CategoryPopUpVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/22.
//

import UIKit

protocol CategoryDelegate: AnyObject {
    
    func sendCategoryResult(category: String)
}

class CategoryPopUpVC: UIViewController {

    weak var categoryDelegate: CategoryDelegate?
    
    private let tableView = UITableView()
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    var categoryResult = ""
    
    var blackView = UIView(frame: UIScreen.main.bounds)
    let categoryData = ["Food", "Grocery",
                        "Plant", "Adcenture",
                        "Exercise", "Treatment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        
        blackViewDynamic()
    }
    
    func blackViewDynamic() {
        
        blackView.backgroundColor = .black
        blackView.alpha = 0
        blackView.isUserInteractionEnabled = true
        blackView.addGestureRecognizer(tapGestureRecognizer)
        presentingViewController?.view.addSubview(blackView)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.blackView.alpha = 0.5
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
    }
    
    @objc func dismissController() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func closeMenu() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.blackView.alpha = 0
        }
    }
    
    @objc func closeView() {
        dismiss(animated: true)
    }
    
    func setUp() {
        
//        gesture = UITapGestureRecognizer(target: self, action: #selector(closeView))
        
        tableView.register(CategoryPopTableViewCell.self, forCellReuseIdentifier: CategoryPopTableViewCell.identifer)
        
        //        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
    }
    
    func style() {
        
        tableView.backgroundColor = .white
        tableView.lkCornerRadius = 15
    }
    
    func layout() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 350)
            
        ])
    }
}

extension CategoryPopUpVC: UITableViewDelegate {
    
}

extension CategoryPopUpVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        
        let label = UILabel()
        
        label.frame = CGRect.init(x: 24, y: 0, width: headerView.frame.width-10, height: headerView.frame.height)
        
        label.text = "Location"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .left
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell( withIdentifier: CategoryPopTableViewCell.identifer, for: indexPath) as? CategoryPopTableViewCell else {
            fatalError("can't find CategoryPopTableViewCell")
        }
        
        cell.categoryLabel.text = categoryData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        categoryResult = categoryData[indexPath.row]
        
        self.categoryDelegate?.sendCategoryResult(category: categoryResult)
        
        closeMenu()
        dismiss(animated: true)
    }
    
}
