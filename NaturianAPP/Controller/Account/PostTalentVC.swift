//
//  PostTalentVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit
//import MobileCoreServices
//import UniformTypeIdentifiers

class CellClass: UITableViewCell {
    
}

class PostTalentVC: UIViewController {
    
    var dataSource = [String]()
    var didPickCategory: String = ""
    let tableView = UITableView()
    let transparentView = UIView()
    
    let postPhoto = UIImageView()
    let titleText = UITextField()
    let seedValueText = UITextField()
    let seedIcon = UIImageView()
    let descriptionText = UITextField()
    let categoryButton = UIButton()
    let seedStack = UIStackView()
    let contentStack = UIStackView()
    let imagePickerController = UIImagePickerController()
    let postButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for camera
        imagePickerController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        setUp()
        style()
        layout()
    }
    
    func setUp() {
        
        postPhoto.isUserInteractionEnabled = true
        postPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhoto)))
        categoryButton.addTarget(self, action: #selector(clickCategory(_:)), for: .touchUpInside)
    }
    
    @objc func clickCategory(_ sender: Any) {
        dataSource = ["Food", "Grocery", "Plant", "Adventure", "Exercise", "Treatment"]
        addTransparentView(frames: categoryButton.frame)
    }
    
    // MARK: Drop down selection
    // show drop down selection button
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    // remove drop down selection button
    @objc func removeTransparentView() {
        let frames = categoryButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
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
    
    func style() {
        
        postPhoto.backgroundColor = .systemGreen
        postPhoto.isUserInteractionEnabled = true
        
        categoryButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        categoryButton.setTitle("Category", for: .normal)
        categoryButton.lkBorderColor = .black
        //        categoryButton.lkCornerRadius = 5
        categoryButton.lkBorderWidth = 1
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.tintColor = .black
        
        titleText.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
        
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        postButton.lkBorderColor = .black
        postButton.lkBorderWidth = 1
        postButton.setTitleColor(.black, for: .normal)
    }
    
    func layout() {
        
        postPhoto.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(postPhoto)
        view.addSubview(categoryButton)
        view.addSubview(seedStack)
        view.addSubview(contentStack)
        view.addSubview(postButton)
        
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
            categoryButton.widthAnchor.constraint(equalToConstant: 120),
            
            contentStack.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 8),
            contentStack.leadingAnchor.constraint(equalTo: postPhoto.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            seedIcon.widthAnchor.constraint(equalToConstant: 20),
            seedIcon.heightAnchor.constraint(equalToConstant: 20),
            
            postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postButton.widthAnchor.constraint(equalToConstant: 120)
            
        ])
    }
}

extension PostTalentVC: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // info 用來取得不同類型的圖片，此 Demo 的型態為 originaImage，其它型態有影片、修改過的圖片等等
        if let image = info[.originalImage] as? UIImage {
            self.postPhoto.image = image
        }
        
        picker.dismiss(animated: true)
    }
}

extension PostTalentVC: UINavigationControllerDelegate {
    
}

// MARK: Drop down tableView
extension PostTalentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryButton.setTitle(dataSource[indexPath.row], for: .normal)
        didPickCategory = dataSource[indexPath.row]
        removeTransparentView()
        print(didPickCategory)
    }
}
