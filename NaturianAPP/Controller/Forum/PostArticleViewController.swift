//
//  PostArticleViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//
import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import JGProgressHUD
import MBProgressHUD
import FirebaseAuth

class PostArticleViewController: UIViewController, UITextViewDelegate {
    
    var userManager = UserManager()
    var forumManager = ForumManager()
    var photoManager = PhotoManager()
    var backButton = UIButton()

    var userID = Auth.auth().currentUser?.uid
//    var userID = "2"
//    let userID = "1"

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

    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let categoryButton = UIButton()

    let contentStack = UIStackView()
    let imagePickerController = UIImagePickerController()
    let postButton = UIButton()
    let cancelButton = UIButton()
    let actStack = UIStackView()
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.text = "Placeholder"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
        textViewDidBeginEditing(descriptionTextView)
        textViewDidEndEditing(descriptionTextView)
        // for camera
        imagePickerController.delegate = self
        setUp()
        layout()
        style()
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
    
    @objc func clickCategory(_ sender: Any) {
        
        //        performSegue(withIdentifier: "categoryPopSegue", sender: nil)
        guard let categoryCV = storyboard?.instantiateViewController(withIdentifier: "CategoryPopUpVC") as? CategoryPopUpVC else {
            print("Can't find CategoryPopUpVC")
            return
        }
        present(categoryCV, animated: true, completion: nil)
        
        categoryCV.categoryDelegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func blackViewShow() {
        
        let blackView = UIView(frame: UIScreen.main.bounds)
        blackView.backgroundColor = .black
        blackView.alpha = 0
        presentingViewController?.view.addSubview(blackView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            blackView.alpha = 0.5
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
                              alertText: "Choose Your Avatar",
                              imagePickerController: imagePickerController)
    }
    
    @objc func didDismiss() {
        dismiss(animated: true)
    }
    
    func setUp() {
        
        postPhotoImage.isUserInteractionEnabled = true
        postPhotoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhoto)))
        categoryButton.addTarget(self, action: #selector(clickCategory(_:)), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(postArticle), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
    }
    
    func style() {
        
        backButton.setImage(UIImage(named: "dismiss"), for: .normal)
//        postPhotoImage.backgroundColor = .NaturianColor.navigationGray
        postPhotoImage.lkCornerRadius = 15
        postPhotoImage.isUserInteractionEnabled = true
        postPhotoImage.image = postPhotoImageX
        postPhotoImage.contentMode = .scaleAspectFit
        
        categoryButton.setImage(UIImage(named: "down"), for: .normal)
        categoryButton.imageView?.contentMode = .scaleAspectFit
        categoryButton.setTitle("CATEGORY", for: .normal)
        categoryButton.semanticContentAttribute = .forceRightToLeft
        categoryButton.lkCornerRadius = 10
        categoryButton.backgroundColor = .NaturianColor.navigationGray
        categoryButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        categoryButton.setTitleColor(.white, for: .normal)
        categoryButton.tintColor = .white

        titleTextField.font = UIFont(name: Roboto.bold.rawValue, size: 30)
        titleTextField.placeholder = "Title"
        
        descriptionTextView.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        descriptionTextView.textAlignment = .justified
        
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 0
        
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
        
    }
    
    func layout() {
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        postPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        actStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backButton)
        view.addSubview(postPhotoImage)
        view.addSubview(categoryButton)
        view.addSubview(contentStack)
        view.addSubview(postButton)
        view.addSubview(descriptionTextView)
        
        view.addSubview(actStack)
        actStack.addArrangedSubview(postButton)
        actStack.addArrangedSubview(cancelButton)
        
        contentStack.addArrangedSubview(titleTextField)
       
        NSLayoutConstraint.activate([
            
            backButton.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            
            categoryButton.trailingAnchor.constraint(equalTo: postPhotoImage.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 40),
            categoryButton.widthAnchor.constraint(equalToConstant: 130),
            categoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            postPhotoImage.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 16),
            postPhotoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            postPhotoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            postPhotoImage.heightAnchor.constraint(equalToConstant: 360),
            
            contentStack.topAnchor.constraint(equalTo: postPhotoImage.bottomAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            descriptionTextView.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 8),
            descriptionTextView.bottomAnchor.constraint(equalTo: postButton.topAnchor, constant: -8),
            descriptionTextView.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: postPhotoImage.trailingAnchor),
            
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
    
    @objc func postArticle() {
        
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
                            
                            let postArticleID = self.forumManager.forumDatabase.document().documentID
                            let createdTime = TimeInterval(Int(Date().timeIntervalSince1970))
                            
                            let userModel = UserModel(name: self.userModels?.name,
                                                      userID: self.userModels?.userID,
                                                      seedValue: self.userModels?.seedValue,
                                                      gender: self.userModels?.gender,
                                                      userAvatar: self.userModels?.userAvatar,
                                                      appliedTalent: self.userModels?.appliedTalent ?? [],
                                                      isAcceptedTalent: self.userModels?.isAcceptedTalent ?? [],
                                                      blockList: self.userModels?.blockList ?? [],
                                                      email: self.userModels?.email
                            )
                            
                           let forumModel = ForumModel(postArticleID: postArticleID,
                                                       userID: self.userID,
                                                       userInfo: userModel,
                                                       category: self.categoryResult,
                                                       title: self.titleTextField.text,
                                                       content: self.descriptionTextView.text,
                                                       createdTime: Int(createdTime),
                                                       images: [url],
                                                       getSeedValue: 0,
                                                       getLikedValue: 0,
                                                       replyIDs: [])
                            
                            self.forumManager.addPostData(postForum: forumModel)
                            
                        case .failure:
                            break
                        }
                    }
                    
                case .failure:
                    break
                }
            }
        }
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
}

extension PostArticleViewController: UINavigationControllerDelegate {
    
}

extension PostArticleViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // info 用來取得不同類型的圖片，此 Demo 的型態為 originaImage，其它型態有影片、修改過的圖片等等
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.postPhotoImage.image = image
            self.postPhotoImageX = image
        }
        
        picker.dismiss(animated: true)
    }
}

extension PostArticleViewController: CategoryDelegate {
    
    func sendCategoryResult(category: String) {
        
        categoryButton.setTitle(category, for: .normal)
        categoryResult = category
    }
}
