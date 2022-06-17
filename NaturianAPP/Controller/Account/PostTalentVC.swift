//
//  PostTalentVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit

class PostTalentVC: UIViewController {
    
    let postPhoto = UIImageView()
    let titleText = UITextField()
    let seedValueText = UITextField()
    let seedIcon = UIImageView()
    let descriptionText = UITextField()
    let categoryButton = UIButton()
    let seedStack = UIStackView()
    let contentStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
    }
    
    func setUp() {
        
    }
    
    func style() {
        
        postPhoto.backgroundColor = .systemGreen
        
        categoryButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        categoryButton.setTitle("Category", for: .normal)
        categoryButton.lkBorderColor = .black
        categoryButton.lkCornerRadius = 5
        categoryButton.lkBorderWidth = 1
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        titleText.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleText.placeholder = "Title"
        
        descriptionText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionText.textAlignment = .justified
        descriptionText.placeholder = "Conetent"

        seedIcon.image = UIImage(named: "Lychee")
        seedValueText.placeholder = "60"
        
        seedStack.axis = .horizontal
        seedStack.alignment = .leading
        seedStack.spacing = 2
        
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 0
    }
    
    func layout() {
        
        postPhoto.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(postPhoto)
        view.addSubview(categoryButton)
        view.addSubview(seedStack)
        view.addSubview(contentStack)
        
        seedStack.addArrangedSubview(seedValueText)
        seedStack.addArrangedSubview(seedIcon)
        
        contentStack.addArrangedSubview(titleText)
        contentStack.addArrangedSubview(seedStack)
        contentStack.addArrangedSubview(descriptionText)
        
        NSLayoutConstraint.activate([
            
            postPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            postPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            postPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            postPhoto.heightAnchor.constraint(equalToConstant: 400),
            
            categoryButton.topAnchor.constraint(equalTo: postPhoto.bottomAnchor, constant: 16),
            categoryButton.leadingAnchor.constraint(equalTo: postPhoto.leadingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 27),
            
            contentStack.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 8),
            contentStack.leadingAnchor.constraint(equalTo: postPhoto.leadingAnchor),
            seedIcon.widthAnchor.constraint(equalToConstant: 20),
            seedIcon.heightAnchor.constraint(equalToConstant: 20)
        
        ])
    }
}
