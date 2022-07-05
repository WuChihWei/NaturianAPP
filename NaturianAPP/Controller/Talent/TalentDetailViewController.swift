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
import FirebaseAuth

class TalentDetailViewController: UIViewController {
    
    var db: Firestore?
    var talentManager = TalentManager()
    var userManager = UserManager()
//    let userID = Auth.auth().currentUser?.uid
        let userID = "2"
    var appliedState: Int = 0
    
    let postPhotoImage = UIImageView()
    let avatarImage = UIImageView()
    let subview = UIView()
    let closeButton = UIButton()

    let titleText = UILabel()
    let categoryBTN = UIButton()
    
    let genderIcon = UIImageView()
    let providerName = UILabel()
    private let nameStack = UIStackView()

    let descriptionText = UILabel()

    let seedValueText = UILabel()
    let seedIcon = UIImageView()
    let seedStack = UIStackView()

    let locationLabel = UILabel()
    let locationIcon = UIImageView()
    private let locationStack = UIStackView()
    
    let providerStack = UIStackView()

    let applyButton = UIButton()
    let contactButton = UIButton()
    let buttonStack = UIStackView()

    var selectedArticle: TalentArticle!
    var userModels: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for camera
        
        setUp()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
        
        view.layoutIfNeeded()
        
        fetchUserData()
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        avatarImage.clipsToBounds = true
        avatarImage.contentMode = .scaleAspectFill
    }

    func fetchUserData() {
        
        userManager.fetchUserData(userID: userID ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.userModels = userModel
                
                DispatchQueue.main.async {
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    @objc func didApply() {
        
        selectedArticle.didApplyID.append(userID )
        
        userModels.appliedTalent.append(selectedArticle.talentPostID)
        
        userManager.updateAppliedTalent(userModel: userModels, userID: userID )
        
        talentManager.updateData(applyTalent: selectedArticle)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didConatact() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {

            fatalError("can't find ChatViewController")
        }
        
//        vc.chatTalentID = selectedArticle.talentPostID ?? "can't find chatTalentPostID"
//        vc.chatToID = selectedArticle.userID ?? "can't find userID"
        
        vc.chatToTalentModel = selectedArticle
        
        self.navigationController?.pushViewController(vc, animated: true)
                
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: false)
    }
    
    func setUp() {
        
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        postPhotoImage.isUserInteractionEnabled = true
        applyButton.addTarget(self, action: #selector(didApply), for: .touchUpInside)
        contactButton.addTarget(self, action: #selector(didConatact), for: .touchUpInside)
    }
    
    func style() {
        
        switchColor()
        
        avatarImage.image = UIImage(named: "")
//        avatarImage.lkBorderColor = .white
        avatarImage.lkCornerRadius = 42
        avatarImage.lkBorderWidth = 4
        avatarImage.backgroundColor = .NaturianColor.lightGray
        let avatarUrl = selectedArticle.userInfo?.userAvatar
        avatarImage.kf.setImage(with: avatarUrl)
        
        postPhotoImage.backgroundColor = .systemGreen
        //        postPhotoImage.contentMode = .scaleAspectFit
        postPhotoImage.isUserInteractionEnabled = true
        let photoUrl = selectedArticle.images[0]
        postPhotoImage.kf.setImage(with: photoUrl)
        postPhotoImage.clipsToBounds = true
        postPhotoImage.contentMode = .scaleAspectFill
        
        closeButton.setImage(UIImage(named: "back_white"), for: .normal)
        
        subview.backgroundColor = .white
        subview.lkCornerRadius = 30
        
        categoryBTN.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.setTitleColor(.white, for: .normal)
//        categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
        categoryBTN.lkCornerRadius = 5
        
        titleText.font = UIFont(name: Roboto.bold.rawValue, size: 24)
        titleText.textAlignment = .left
        titleText.text = selectedArticle.title
        titleText.textColor = .NaturianColor.darkGray
        titleText.numberOfLines = 0
        
        descriptionText.font = UIFont(name: Roboto.regular.rawValue, size: 16)
        descriptionText.textAlignment = .justified
        descriptionText.text = selectedArticle.content
        descriptionText.numberOfLines = 0
        
        seedIcon.image = UIImage(named: "seed")
        
        seedValueText.text = "\(selectedArticle.seedValue ?? 0)"
        seedValueText.font = UIFont(name: Roboto.bold.rawValue, size: 26)
        seedValueText.textColor = .NaturianColor.darkGray

        locationLabel.text = selectedArticle.location ?? ""
        locationLabel.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        locationLabel.textColor = .NaturianColor.navigationGray
        locationIcon.image = UIImage(named: "location_gray")
        
        genderIcon.image = UIImage(named: "male")
        providerName.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        providerName.textColor = .NaturianColor.navigationGray
        providerName.text = selectedArticle.userInfo?.name

        seedStack.axis = .horizontal
        seedStack.alignment = .trailing
        seedStack.spacing = 6
        
        nameStack.axis = .horizontal
        nameStack.alignment = .center
        nameStack.spacing = 6
        
        locationStack.axis = .horizontal
        locationStack.alignment = .center
        locationStack.spacing = 6
        
        providerStack.axis = .vertical
        providerStack.alignment = .leading
        providerStack.spacing = 2
        
        applyButton.setTitle("Apply", for: .normal)
        applyButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        applyButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        applyButton.lkBorderColor = .NaturianColor.darkGray
        applyButton.lkBorderWidth = 2
        applyButton.lkCornerRadius = 24
        
        contactButton.setTitle("Contact", for: .normal)
        contactButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        contactButton.setTitleColor(.black, for: .normal)

        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.spacing = 20
    }
    
    func layout() {
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        postPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        titleText.translatesAutoresizingMaskIntoConstraints = false
        categoryBTN.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        providerStack.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(postPhotoImage)
        postPhotoImage.addSubview(avatarImage)
        
        view.addSubview(closeButton)
        view.addSubview(subview)
        
        subview.addSubview(titleText)
        subview.addSubview(categoryBTN)
        subview.addSubview(seedStack)
        subview.addSubview(providerStack)
        subview.addSubview(categoryBTN)
        subview.addSubview(descriptionText)

        subview.addSubview(buttonStack)
        
        seedStack.addArrangedSubview(seedIcon)
        seedStack.addArrangedSubview(seedValueText)
        
        providerStack.addArrangedSubview(nameStack)
        providerStack.addArrangedSubview(locationStack)
        
        nameStack.addArrangedSubview(genderIcon)
        nameStack.addArrangedSubview(providerName)
        
        locationStack.addArrangedSubview(locationIcon)
        locationStack.addArrangedSubview(locationLabel)

        buttonStack.addArrangedSubview(applyButton)
        buttonStack.addArrangedSubview(contactButton)

        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            postPhotoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            postPhotoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            postPhotoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            postPhotoImage.heightAnchor.constraint(equalToConstant: 400),
       
            avatarImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            avatarImage.heightAnchor.constraint(equalToConstant: 84),
            avatarImage.widthAnchor.constraint(equalToConstant: 84),
    
            subview.topAnchor.constraint(equalTo: postPhotoImage.bottomAnchor, constant: -40),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            seedStack.topAnchor.constraint(equalTo: subview.topAnchor, constant: 22),
            seedStack.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            seedIcon.heightAnchor.constraint(equalToConstant: 26),
            seedIcon.widthAnchor.constraint(equalToConstant: 26),
            
            titleText.topAnchor.constraint(equalTo: seedStack.bottomAnchor, constant: 6),
            titleText.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            titleText.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            
            categoryBTN.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 6),
            categoryBTN.leadingAnchor.constraint(equalTo: titleText.leadingAnchor),
            categoryBTN.heightAnchor.constraint(equalToConstant: 24),
            categoryBTN.widthAnchor.constraint(equalToConstant: 90),
            
            providerStack.topAnchor.constraint(equalTo: seedStack.topAnchor),
            providerStack.leadingAnchor.constraint(equalTo: titleText.leadingAnchor),
            
            genderIcon.widthAnchor.constraint(equalToConstant: 14),
            genderIcon.heightAnchor.constraint(equalToConstant: 14),
            nameStack.heightAnchor.constraint(equalToConstant: 16),
            
            locationStack.heightAnchor.constraint(equalToConstant: 14),
            locationIcon.widthAnchor.constraint(equalToConstant: 14),
            
            descriptionText.leadingAnchor.constraint(equalTo: titleText.leadingAnchor),
            descriptionText.topAnchor.constraint(equalTo: categoryBTN.bottomAnchor, constant: 8),
            descriptionText.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 130),
            applyButton.heightAnchor.constraint(equalToConstant: 48),

            contactButton.widthAnchor.constraint(equalToConstant: 130),
            contactButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func switchColor() {
        
        switch selectedArticle.userInfo?.gender {
            
        case "Male":
            genderIcon.image = UIImage(named: "male")
        case "Female":
            genderIcon.image = UIImage(named: "female")
        case "Undefined":
            genderIcon.image = UIImage(named: "undefined")
        default:
            break
        }
        
        switch selectedArticle.category {
            
        case "Food":
            categoryBTN.backgroundColor = .NaturianColor.foodYellow
            avatarImage.lkBorderColor = .NaturianColor.foodYellow
        case "Plant":
            categoryBTN.backgroundColor = .NaturianColor.plantGreen
            avatarImage.lkBorderColor = .NaturianColor.plantGreen
        case "Adventure":
            categoryBTN.backgroundColor = .NaturianColor.adventurePink
            avatarImage.lkBorderColor = .NaturianColor.adventurePink
        case "Grocery":
            categoryBTN.backgroundColor = .NaturianColor.groceryBlue
            avatarImage.lkBorderColor = .NaturianColor.groceryBlue
        case "Exercise":
            categoryBTN.backgroundColor = .NaturianColor.exerciseBlue
            avatarImage.lkBorderColor = .NaturianColor.exerciseBlue
        case "Treatment":
            categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
            avatarImage.lkBorderColor = .NaturianColor.treatmentGreen
        default:
            break
        }
    }
}
