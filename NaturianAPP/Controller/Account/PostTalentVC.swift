//
//  PostTalentVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import FirebaseAuth
import Lottie

class PostTalentVC: UIViewController, UITextViewDelegate {
    
    var userManager = UserManager()
    var talentManager = TalentManager()
    var photoManager = PhotoManager()
    var backButton = UIButton()
    let cancelButton = UIButton()
    var userID = Auth.auth().currentUser?.uid
//    let userID = "2"
    let locationIcon = UIImageView()
    var userModels: UserModel?
    
    var categoryResult = ""
    var locationResult = ""
    
    var db: Firestore?
    var catagoryDataSource = [String]()
    var didPickCategory: String = ""
    let categoryTableView = UITableView()
    let transparentView = UIView()
    var accountInfo: UserModel?
    
    var postPhotoImage = UIImageView()
    var postPhotoImageX = UIImage(named: "takephoto")
    let titleText = UITextField()
    let seedValueText = UITextField()
    let seedIcon = UIImageView()
    let descriptionTextView = UITextView()
    let categoryButton = UIButton()
    private let locationStack = UIStackView()
    
    let seedStack = UIStackView()
    let contentStack = UIStackView()
    let imagePickerController = UIImagePickerController()
    let postButton = UIButton()
    let locationBtn = UIButton()
    var selectedImage: UIImage!
    
    let actStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for camera
        imagePickerController.delegate = self
        setUp()
        style()
        layout()
        tabBarController?.tabBar.isHidden = true
        
        descriptionTextView.text = "Please describe your talent here"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
        textViewDidBeginEditing(descriptionTextView)
        textViewDidEndEditing(descriptionTextView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
    }
    
    override func viewDidLayoutSubviews() {
        
        view.layoutIfNeeded()
        postPhotoImage.layoutIfNeeded()
        postPhotoImage.clipsToBounds = true
        postPhotoImage.contentMode = .scaleAspectFill
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupLottie() {
        let animationView = AnimationView(name: "lf20_s6zewgds")
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        
        view.addSubview(animationView)
        animationView.play()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Text Your Talent Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func fetchUserData() {
        
        userManager.fetchUserData(userID: userID ?? "" ) { [weak self] result in
            
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
    
    // MARK: setup camera enviroment
    @objc func tapPhoto(tapGestureRecognizer: UITapGestureRecognizer) {
        
        photoManager.tapPhoto(controller: self,
                              alertText: "Choose Your Photo",
                              imagePickerController: imagePickerController)
    }
    
    func setUp() {
        
        postPhotoImage.isUserInteractionEnabled = true
        postPhotoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhoto)))
        locationBtn.addTarget(self, action: #selector(clickLocation(_:)), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(clickCategory(_:)), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(postTalent), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        
    }
    
    @objc func didDismiss() {
        //        navigationController?.popViewController(animated: true)
        dismiss(animated: false)
    }
    
    func style() {
        
        backButton.setImage(UIImage(named: "dismiss"), for: .normal)
        postPhotoImage.lkCornerRadius = 15
        postPhotoImage.isUserInteractionEnabled = true
        postPhotoImage.image = postPhotoImageX
        postPhotoImage.contentMode = .scaleAspectFill
        postPhotoImage.backgroundColor = .blue
        
        categoryButton.setImage(UIImage(named: "down"), for: .normal)
        categoryButton.imageView?.contentMode = .scaleAspectFit
        categoryButton.setTitle("CATEGORY", for: .normal)
        categoryButton.semanticContentAttribute = .forceRightToLeft
        categoryButton.lkCornerRadius = 10
        categoryButton.backgroundColor = .NaturianColor.lightGray2
        categoryButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        categoryButton.setTitleColor(.white, for: .normal)
        categoryButton.tintColor = .white
        
        locationIcon.image = UIImage(named: "darklocation")
        locationBtn.setImage(UIImage(named: "down2"), for: .normal)
        locationBtn.tintColor = .darkGray
        locationBtn.setTitle("Location", for: .normal)
        locationBtn.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        locationBtn.setTitleColor(.NaturianColor.darkGray, for: .normal)
        locationBtn.tintColor = .NaturianColor.darkGray
        locationBtn.semanticContentAttribute = .forceRightToLeft
        
        titleText.font = UIFont(name: Roboto.bold.rawValue, size: 30)
        titleText.placeholder = "Title"
        
        descriptionTextView.font = UIFont(name: Roboto.medium.rawValue, size: 16)
        descriptionTextView.textAlignment = .justified
        
        seedIcon.image = UIImage(named: "seedgray")
        seedValueText.placeholder = "Your Talent Value"
        seedValueText.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        seedValueText.keyboardType = .numberPad
        
        seedStack.axis = .horizontal
        seedStack.alignment = .leading
        seedStack.spacing = 4
        
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 3
        
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(.white, for: .normal)
        postButton.backgroundColor = UIColor.NaturianColor.treatmentGreen
        postButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        postButton.lkCornerRadius = 24
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.setTitleColor(UIColor.NaturianColor.treatmentGreen, for: .normal)
        
        actStack.axis = .horizontal
        actStack.alignment = .center
        actStack.spacing = 14
        
        locationStack.axis = .horizontal
        locationStack.alignment = .center
        locationStack.spacing = 6
    }
    
    func layout() {
        
        titleText.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        postPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        locationBtn.translatesAutoresizingMaskIntoConstraints = false
        actStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        view.addSubview(titleText)
        
        view.addSubview(postPhotoImage)
        view.addSubview(categoryButton)
        view.addSubview(seedStack)
        view.addSubview(contentStack)
        //        view.addSubview(postButton)
        view.addSubview(descriptionTextView)
        view.addSubview(actStack)
        
        actStack.addArrangedSubview(postButton)
        actStack.addArrangedSubview(cancelButton)
        
        seedStack.addArrangedSubview(seedIcon)
        seedStack.addArrangedSubview(seedValueText)
        
        locationStack.addArrangedSubview(locationIcon)
        locationStack.addArrangedSubview(locationBtn)
        //        contentStack.addArrangedSubview(titleText)
        contentStack.addArrangedSubview(seedStack)
        contentStack.addArrangedSubview(locationStack)
        
        NSLayoutConstraint.activate([
            
            backButton.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            
            postPhotoImage.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 16),
            postPhotoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            postPhotoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            postPhotoImage.heightAnchor.constraint(equalToConstant: 320),
            
            categoryButton.trailingAnchor.constraint(equalTo: postPhotoImage.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 40),
            categoryButton.widthAnchor.constraint(equalToConstant: 130),
            categoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            titleText.topAnchor.constraint(equalTo: postPhotoImage.bottomAnchor, constant: 6),
            titleText.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 4),
            contentStack.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            locationIcon.widthAnchor.constraint(equalToConstant: 11),
            locationIcon.heightAnchor.constraint(equalToConstant: 13),
            
            descriptionTextView.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 4),
            descriptionTextView.bottomAnchor.constraint(equalTo: postButton.topAnchor, constant: 6),
            descriptionTextView.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor, constant: -6),
            descriptionTextView.trailingAnchor.constraint(equalTo: postPhotoImage.trailingAnchor),
            
            seedIcon.widthAnchor.constraint(equalToConstant: 14),
            seedIcon.heightAnchor.constraint(equalToConstant: 14),
            
            actStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            actStack.heightAnchor.constraint(equalToConstant: 48),
            postButton.widthAnchor.constraint(equalToConstant: 130),
            postButton.heightAnchor.constraint(equalToConstant: 48),
            cancelButton.widthAnchor.constraint(equalToConstant: 130),
            cancelButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: Upload post
    @objc func postTalent() {
        
        setupLottie()
        
        let imageData = self.postPhotoImage.image?.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        
        if let data = imageData {
            
            fileReference.putData(data, metadata: nil) { result in
                
                switch result {
                    
                case .success:
                    
                    fileReference.downloadURL { result in
                        switch result {
                            
                        case .success(let url):
                            
                            let talenPostID = self.talentManager.database.document().documentID
                            let createdTime = TimeInterval(Int(Date().timeIntervalSince1970))
                            let title = self.titleText.text
                            let userID = self.userID
                            let content = self.descriptionTextView.text
                            let category = self.categoryResult
                            let location = self.locationResult
                            let seedValue = (self.seedValueText.text! as NSString).intValue
                            
                            let userModel = UserModel(name: self.userModels?.name,
                                                      userID: self.userModels?.userID,
                                                      seedValue: self.userModels?.seedValue,
                                                      gender: self.userModels?.gender,
                                                      userAvatar: self.userModels?.userAvatar,
                                                      appliedTalent: self.userModels?.appliedTalent ?? [],
                                                      isAcceptedTalent: self.userModels?.isAcceptedTalent ?? [],
                                                      blockList: self.userModels?.blockList ?? [],
                                                      likedTalentList: self.userModels?.likedTalentList ?? [],
                                                      likedForumList: self.userModels?.likedForumList ?? [],
                                                      didGiveSeed: self.userModels?.didGiveSeed ?? [],
                                                      email: self.userModels?.email
                            )
                            
                            let talenArticle = TalentArticle(talentPostID: talenPostID,
                                                             userID: userID,
                                                             userInfo: userModel,
                                                             category: category,
                                                             location: location,
                                                             title: title,
                                                             content: content,
                                                             images: ["\(url)"],
                                                             seedValue: seedValue,
                                                             createdTime: Int(createdTime),
                                                             didApplyID: [""],
                                                             didAcceptID: [""]
                            )
                            
                            self.talentManager.addData(postTalent: talenArticle)
                            
                        case .failure:
                            break
                        }
                    }
                    
                case .failure:
                    break
                }
            }
        }
        dismiss(animated: false)
        navigationController?.popViewController(animated: true)
    }
}

extension PostTalentVC: UINavigationControllerDelegate {
    
}

extension PostTalentVC: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.postPhotoImage.image = image
            self.postPhotoImageX = image
        }
        picker.dismiss(animated: true)
    }
}

extension PostTalentVC: CategoryDelegate {
    
    func sendCategoryResult(category: String) {
        
        categoryButton.setTitle(category, for: .normal)
        categoryResult = category
    }
    
}

extension PostTalentVC: LocationDelegate {
    func sendLocationResult(location: String) {
        locationBtn.setTitle(location, for: .normal)
        locationResult = location
    }
    
}

extension PostTalentVC {
    
    func blackViewShow() {
        
        let blackView = UIView(frame: UIScreen.main.bounds)
        blackView.backgroundColor = .black
        blackView.alpha = 0
        presentingViewController?.view.addSubview(blackView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            blackView.alpha = 0.5
        }
    }
    
    @objc func clickCategory(_ sender: Any) {
        
        guard let categoryCV = storyboard?.instantiateViewController(withIdentifier: "CategoryPopUpVC") as? CategoryPopUpVC else {
            print("Can't find CategoryPopUpVC")
            return
        }
        present(categoryCV, animated: true, completion: nil)
        categoryCV.categoryDelegate = self
    }
    
    @objc func clickLocation(_ sender: Any) {
        
        guard let locationCV = storyboard?.instantiateViewController(withIdentifier: "LocationPopUpVC") as? LocationPopUpVC else {
            print("Can't find LocationPopUpVC")
            return
        }
        present(locationCV, animated: true, completion: nil)
        
        locationCV.locationDelegate = self
    }
}
