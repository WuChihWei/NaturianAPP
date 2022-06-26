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
import JGProgressHUD
import MBProgressHUD
import SwiftUI

class PostTalentVC: UIViewController {
    
    var userManager = UserManager()
    var talentManager = TalentManager()
        
    var userID = "1"
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
    let titleText = UITextField()
    let seedValueText = UITextField()
    let seedIcon = UIImageView()
    let descriptionText = UITextView()
    let categoryButton = UIButton()
    
    let seedStack = UIStackView()
    let contentStack = UIStackView()
    let imagePickerController = UIImagePickerController()
    let postButton = UIButton()
    let locationBtn = UIButton()
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for camera
        imagePickerController.delegate = self
        setUp()
        style()
        layout()
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
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
    
    @objc func clickLocation(_ sender: Any) {
//        performSegue(withIdentifier: "locationPopSegue", sender: nil)
        guard let locationCV = storyboard?.instantiateViewController(withIdentifier: "LocationPopUpVC") as? LocationPopUpVC else {
            print("Can't find LocationPopUpVC")
            return
        }
        present(locationCV, animated: true, completion: nil)

        locationCV.locationDelegate = self
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
        
        userManager.fetchUserData(userID: userID) {
            
            [weak self] result in
            
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
        
        let controller = UIAlertController(title: "Camera? Gallery? Album?", message: "", preferredStyle: .alert)
        controller.view.tintColor = UIColor.gray
        
        // Camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.takePicture()
        }
        controller.addAction(cameraAction)
        
        // Photo
        let photoLibraryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.openPhotoLibrary()
        }
        controller.addAction(photoLibraryAction)
        
        // Gallery
        let savedPhotoAlbumAction = UIAlertAction(title: "Album", style: .default) { _ in
            self.openPhotosAlbum()
        }
        controller.addAction(savedPhotoAlbumAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // turn on camera
    func takePicture() {
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true)
    }
    
    // turn on libary
    func openPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true)
    }
    
    // turn on album
    func openPhotosAlbum() {
        imagePickerController.sourceType = .savedPhotosAlbum
        self.present(imagePickerController, animated: true)
    }
    
    func setUp() {
        
        postPhotoImage.isUserInteractionEnabled = true
        postPhotoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhoto)))
        locationBtn.addTarget(self, action: #selector(clickLocation(_:)), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(clickCategory(_:)), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(postTalent), for: .touchUpInside)
    }
    
    func style() {
        
        postPhotoImage.backgroundColor = .systemGreen
        //        postPhotoImage.contentMode = .scaleAspectFit
        postPhotoImage.isUserInteractionEnabled = true
        
        categoryButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        
        categoryButton.setTitle("Category", for: .normal)
        categoryButton.lkBorderColor = .black
        categoryButton.lkBorderWidth = 1
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.tintColor = .black
        
        locationBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        locationBtn.setTitle("Location", for: .normal)
        locationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        locationBtn.setTitleColor(.black, for: .normal)
        locationBtn.tintColor = .black
        
        titleText.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleText.placeholder = "Title"
        
        descriptionText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionText.textAlignment = .justified
        //        descriptionText.placeholder = "Conetent"
        descriptionText.backgroundColor = .gray
        descriptionText.lkBorderColor = .gray
        
        seedIcon.image = UIImage(named: "Lychee")
        seedValueText.placeholder = "60"
        
        seedStack.axis = .horizontal
        seedStack.alignment = .leading
        seedStack.spacing = 2
        
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 0
        
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        postButton.lkBorderColor = .black
        postButton.lkBorderWidth = 1
        postButton.setTitleColor(.black, for: .normal)
        
    }
    
    func layout() {
        
        postPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        locationBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(postPhotoImage)
        view.addSubview(categoryButton)
        view.addSubview(seedStack)
        view.addSubview(contentStack)
        view.addSubview(postButton)
        view.addSubview(descriptionText)
        
        seedStack.addArrangedSubview(seedValueText)
        seedStack.addArrangedSubview(seedIcon)
        
        contentStack.addArrangedSubview(titleText)
        contentStack.addArrangedSubview(seedStack)
        contentStack.addArrangedSubview(locationBtn)
        
        NSLayoutConstraint.activate([
            
            postPhotoImage.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 16),
            postPhotoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            postPhotoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            postPhotoImage.heightAnchor.constraint(equalToConstant: 400),
            
//            categoryButton.topAnchor.constraint(equalTo: postPhotoImage.bottomAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: postPhotoImage.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 27),
            categoryButton.widthAnchor.constraint(equalToConstant: 120),
            categoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            contentStack.topAnchor.constraint(equalTo: postPhotoImage.bottomAnchor, constant: 8),
            contentStack.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            descriptionText.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 8),
            descriptionText.bottomAnchor.constraint(equalTo: postButton.topAnchor, constant: 8),
            descriptionText.leadingAnchor.constraint(equalTo: postPhotoImage.leadingAnchor),
            descriptionText.trailingAnchor.constraint(equalTo: postPhotoImage.trailingAnchor),
            
            seedIcon.widthAnchor.constraint(equalToConstant: 20),
            seedIcon.heightAnchor.constraint(equalToConstant: 20),
            
            postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    // MARK: Upload post
    
    @objc func postTalent() {
        
        let imageData = self.postPhotoImage.image?.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        
        if let data = imageData {
            
            fileReference.putData(data, metadata: nil) { result in
                
                switch result {
                    
                case .success(_):
                    
                    fileReference.downloadURL { result in
                        switch result {
                            
                        case .success(let url):
                            
                            let talenPostID = self.talentManager.database.document().documentID
                            let createdTime = TimeInterval(Int(Date().timeIntervalSince1970))
                            let title = self.titleText.text
                            let userID = "1" // 以後為登入後的userID
                            let content = self.descriptionText.text
                            let category = self.categoryResult
                            let location = self.locationResult
                            let seedValue = (self.seedValueText.text! as NSString).intValue
                            let userModel = UserModel(name: self.userModels?.name,
                                                      userID: self.userModels?.userID,
                                                      seedValue: self.userModels?.seedValue,
                                                      gender: self.userModels?.gender,
                                                      userAvatar: self.userModels?.userAvatar,
                                                      appliedTalent: [],
                                                      isAccepetedTalent: []
                            )
                            
                            let talenArticle = TalentArticle(talentPostID: talenPostID,
                                                             userID: userID,
                                                             userInfo: userModel,
                                                             category: category,
                                                             location: location,
                                                             title: title,
                                                             content: content,
                                                             images: [url],
                                                             seedValue: seedValue,
                                                             createdTime: Int(createdTime),
                                                             didApplyID: [],
                                                             didAcceptID: []
                            )
                            
                            self.talentManager.addData(postTalent: talenArticle)

                        case .failure(_):
                            break
                        }
                    }
                    
                case .failure(_):
                    break
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension PostTalentVC: UINavigationControllerDelegate {
    
}

extension PostTalentVC: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // info 用來取得不同類型的圖片，此 Demo 的型態為 originaImage，其它型態有影片、修改過的圖片等等
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.postPhotoImage.image = image
            //            selectedImage = self.postPhotoImage.image
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
