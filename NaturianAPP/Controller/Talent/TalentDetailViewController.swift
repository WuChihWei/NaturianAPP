//
//  TalentDetailViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/18.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class TalentDetailViewController: UIViewController {
    
    var db: Firestore?
    var talentManager = TalentManager()
    var userManager = UserManager()
    let useID = "123"
    var appliedState: Int = 0
    
    let postPhotoImage = UIImageView()
    let titleText = UILabel()
    let seedValueText = UILabel()
    let seedIcon = UIImageView()
    let descriptionText = UILabel()
    let categoryLabel = UILabel()
    let applyButton = UIButton()
    let seedStack = UIStackView()
    let contentStack = UIStackView()
    
    var selectedArticle: TalentArticle!
    var userArticle: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for camera
        
        setUp()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func didApply() {
        
        selectedArticle.didApplyID.append(useID)
        //        userArticle.appliedTalent.append(selectedArticle.talentPostID ?? "")
        
        talentManager.updateData(applyTalent: selectedArticle)
        //        userManager.updateData(userModel: userArticle)
        //        presentingViewController?.dismiss(animated: false, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func setUp() {
        
        postPhotoImage.isUserInteractionEnabled = true
        applyButton.addTarget(self, action: #selector(didApply), for: .touchUpInside)
    }
    
    func style() {
        
        postPhotoImage.backgroundColor = .systemGreen
        //        postPhotoImage.contentMode = .scaleAspectFit
        postPhotoImage.isUserInteractionEnabled = true
        let photoUrl = selectedArticle.images[0]
        postPhotoImage.kf.setImage(with: photoUrl)
        
        categoryLabel.lkBorderColor = .black
        //        categoryButton.lkCornerRadius = 5
        categoryLabel.lkBorderWidth = 1
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        categoryLabel.tintColor = .black
        categoryLabel.text = selectedArticle.category
        categoryLabel.textAlignment = .center
        
        titleText.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleText.text = selectedArticle.title
        
        descriptionText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionText.textAlignment = .justified
        descriptionText.text = selectedArticle.content
        
        seedIcon.image = UIImage(named: "Lychee")
        seedValueText.text = selectedArticle.seedValue
        
        seedStack.axis = .horizontal
        seedStack.alignment = .leading
        seedStack.spacing = 2
        
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 0
        
        applyButton.setTitle("Apply", for: .normal)
        applyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        applyButton.lkBorderColor = .black
        applyButton.lkBorderWidth = 1
        applyButton.setTitleColor(.black, for: .normal)
        
    }
    
    func layout() {
        
        postPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(postPhotoImage)
        view.addSubview(categoryLabel)
        view.addSubview(seedStack)
        view.addSubview(contentStack)
        view.addSubview(applyButton)
        
        seedStack.addArrangedSubview(seedValueText)
        seedStack.addArrangedSubview(seedIcon)
        
        contentStack.addArrangedSubview(titleText)
        contentStack.addArrangedSubview(seedStack)
        contentStack.addArrangedSubview(descriptionText)
        
        NSLayoutConstraint.activate([
            
            postPhotoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            postPhotoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            postPhotoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            postPhotoImage.heightAnchor.constraint(equalToConstant: 400),
            
            categoryLabel.topAnchor.constraint(equalTo: postPhotoImage.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor),
            categoryLabel.heightAnchor.constraint(equalToConstant: 27),
            categoryLabel.widthAnchor.constraint(equalToConstant: 120),
            
            contentStack.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            contentStack.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            seedIcon.widthAnchor.constraint(equalToConstant: 20),
            seedIcon.heightAnchor.constraint(equalToConstant: 20),
            
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
