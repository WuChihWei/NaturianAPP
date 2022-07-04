//
//  ProfileVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/29.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class GenderCell: UITableViewCell {
    
}

class ProfileVC: UIViewController {
    
    var addTransparentManager = AddDropDownField()
//    let userID = Auth.auth().currentUser?.uid
    let userID = "2"

    var photoManager = PhotoManager()
    var profileManager = UserFirebaseManager()
    let closeBtn = UIButton()
    var userImage = UIImageView()
    let logoImage = UIImageView()
    let photoButton = UIButton()
    let comfirmButton = UIButton()
    
    let nameLabel = UILabel()
    var nameTextField = UITextField()
    
    let genderLabel = UILabel()
    var genderButton = UIButton()
    var dataSource = [String]()
    let tableView = UITableView()
    var profileModels: UserModel!
    let imagePickerController = UIImagePickerController()

    var genderResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        setup()
        style()
        layout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GenderCell.self, forCellReuseIdentifier: "Cell")
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
        userImage.clipsToBounds = true
        logoImage.clipsToBounds = true
        photoButton.clipsToBounds = true
        
        photoButton.lkCornerRadius = photoButton.bounds.height / 2
        photoButton.lkBorderWidth = 2
        photoButton.lkBorderColor = .NaturianColor.lightGray
        
        userImage.lkCornerRadius = userImage.bounds.height / 2
        userImage.lkBorderColor = .NaturianColor.treatmentGreen
        userImage.lkBorderWidth = 4
        userImage.contentMode = .scaleAspectFill
        
        nameTextField.lkCornerRadius = 15
        genderButton.lkCornerRadius = 15
        
        genderButton.lkCornerRadius = 15
        
        comfirmButton.lkCornerRadius = photoButton.bounds.height / 2
    }
    
    @objc func clickGender(_ sender: Any) {
        dataSource = ["Male", "Female",
        "Undefined"]
        
        addTransparentManager.addWithoutTransparent(radius: 15, tableView: tableView,
                                                    view: self.view,
                                                    frames: genderButton.frame)
    }
    
    @objc func selecetPhoto() {
        
        photoManager.tapPhoto(controller: self,
                              alertText: "Choose Your Avatar",
                              imagePickerController: imagePickerController)
    }
    
    @objc func upDate() {
        
        let imageData = self.userImage.image?.jpegData(compressionQuality: 0.8)
        
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
                            
//                            let url = URL(string: "myphotoapp:Vacation?index=1")
                            guard let name = self.nameTextField.text else {return}
//                            guard let userID = self.userID else {return}
                            let gender = self.genderResult
                            let userAvatar = "\(url)"
//                            let createdTime = Date()
                            guard let email = Auth.auth().currentUser?.email else {return}

//                            let userInfo = UserModel(name: name,
//                                                         userID: userID,
//                                                         seedValue: 420,
//                                                         gender: gender,
//                                                         userAvatar: userAvatar,
//                                                         appliedTalent: [],
//                                                         isAccepetedTalent: [],
//                                                         createdTime: createdTime,
//                                                         email: email
//                            )
//
                            self.profileManager.replaceData(name: name, uid: self.userID ?? "", email: email, gender: gender, userAvatar: userAvatar)

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
    
    @objc func closePage() {
        
        dismiss(animated: true)
    }
    
    func setup() {
        
        photoButton.addTarget(self, action: #selector(selecetPhoto), for: .touchUpInside)
        genderButton.addTarget(self, action: #selector(clickGender(_:)), for: .touchUpInside)
        comfirmButton.addTarget(self, action: #selector(upDate), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(closePage), for: .touchUpInside)
    }
    
    func style() {
        
        view.backgroundColor = .NaturianColor.lightGray
        
        userImage.image = UIImage(named: "userImage")

        closeBtn.setImage(UIImage(named: "back"), for: .normal)

//        userImage.backgroundColor = .NaturianColor.treatmentGreen
        
        photoButton.setImage(UIImage(named: "camera"), for: .normal)
        
        logoImage.image = UIImage(named: "naturianLogo")
        
        nameLabel.text = "YOUR NAME"
        nameLabel.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        nameLabel.textColor = .NaturianColor.treatmentGreen
        
        genderLabel.text = "GENDER"
        genderLabel.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        genderLabel.textColor = .NaturianColor.treatmentGreen
        
        nameTextField.placeholder = "Text Your Name"
        nameTextField.addPadding(.left(14))
        nameTextField.textColor = .NaturianColor.navigationGray
        nameTextField.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        nameTextField.backgroundColor = .white
        
        genderButton.setTitle("Pick Your Gender", for: .normal)
        genderButton.setTitleColor(.NaturianColor.navigationGray, for: .normal)
        genderButton.contentEdgeInsets.left = 14
        genderButton.contentHorizontalAlignment = .left
        genderButton.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        genderButton.backgroundColor = .white
        
        comfirmButton.setTitle("Comfirm", for: .normal)
        comfirmButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 18)
        comfirmButton.backgroundColor = .NaturianColor.treatmentGreen
        
    }
    
    func layout() {
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        userImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderButton.translatesAutoresizingMaskIntoConstraints = false
        comfirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(closeBtn)
        view.addSubview(userImage)
        view.addSubview(logoImage)
        view.addSubview(photoButton)

//        userImage.addSubview(photoButton)

        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(genderLabel)
        view.addSubview(genderButton)
        view.addSubview(comfirmButton)
        
        NSLayoutConstraint.activate([
            
            closeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeBtn.heightAnchor.constraint(equalToConstant: 36),
            closeBtn.widthAnchor.constraint(equalToConstant: 36),
            
            comfirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            comfirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            comfirmButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 80),
            comfirmButton.heightAnchor.constraint(equalToConstant: 48),
            
            userImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 150),
            userImage.heightAnchor.constraint(equalToConstant: 150),
            
            photoButton.trailingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: -7),
            photoButton.bottomAnchor.constraint(equalTo: userImage.bottomAnchor, constant: -7),
            photoButton.widthAnchor.constraint(equalToConstant: 38),
            photoButton.heightAnchor.constraint(equalToConstant: 38),
            
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 14),
            logoImage.widthAnchor.constraint(equalToConstant: 134),
            logoImage.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 64),
            nameLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: 14),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: comfirmButton.leadingAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: comfirmButton.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: comfirmButton.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            genderLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            genderLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: 14),
            
            genderButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            genderButton.leadingAnchor.constraint(equalTo: comfirmButton.leadingAnchor),
            genderButton.trailingAnchor.constraint(equalTo: comfirmButton.trailingAnchor),
            genderButton.heightAnchor.constraint(equalToConstant: 48)
                        
        ])
    }
    
    @objc func removeTransparentView() {
        let frames = genderButton.frame
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            //            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x,
                                          y: frames.origin.y + frames.height,
                                          width: frames.width,
                                          height: 0)
        }, completion: nil)
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.textLabel?.textAlignment = .left
        cell.selectionStyle = .none
        self.genderResult = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        genderButton.setTitle(dataSource[indexPath.row], for: .normal)
//        profileModels.gender = dataSource[indexPath.row]
        removeTransparentView()
    }
}

extension ProfileVC: UINavigationControllerDelegate {
    
}

extension ProfileVC: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.userImage.image = image
        }
        
        picker.dismiss(animated: true)
    }
}
