//
//  AccountViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit
import Kingfisher

protocol AccountVCDelegate: AnyObject {
    func sendAccountInfo(userModel: UserModel?)
}

class AccountViewController: UIViewController {
    
    weak var accountDelegate: AccountVCDelegate?
//    let viewController = UIViewController()

    var userManager = UserManager()
    var userModels: UserModel?
    var userID = "1"
    
    let userAvatar = UIImageView()
    let editImageBtn = UIButton()
    
    let nameLabel = UILabel()
    var userName = UILabel()
    let nameStack = UIStackView()
    
    let seedLabel = UILabel()
    var seedValueLabel = UILabel()
    let seedIcon = UIImageView()
    
    let barcodeUIImage = UIImageView()
    let userIDLabel = UILabel()
    
    let transferBtn = UIButton()
    let talentBtn = UIButton()
    let boardBtn = UIButton()
    
    let buttonStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewController.hidesBottomBarWhenPushed = true

        setup()
        setStyle()
        layout()
        //        fetchUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        fetchUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        
        view.layoutIfNeeded()
        barcodeUIImage.clipsToBounds = true
        userAvatar.clipsToBounds = true
//        view.backgroundColor = .lightGray
        
        transferBtn.lkCornerRadius = transferBtn.bounds.width / 2
        talentBtn.lkCornerRadius = transferBtn.bounds.width / 2
        boardBtn.lkCornerRadius = transferBtn.bounds.width / 2
        barcodeUIImage.contentMode = .scaleAspectFill
        userAvatar.lkCornerRadius = userAvatar.bounds.width / 2
  }
    
    func generateBarcode(userID: String) -> UIImage? {
        
        let data = userID.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let filter = CIFilter.init(name: "CICode128BarcodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 24, y: 16)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    func fetchUserData() {
        
        userManager.fetchUserData(userID: userID) {
            
            [ weak self ] result in
            
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
    
    @objc func didTapTalent() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "TalentManageViewController") as? TalentManageViewController else {
            
            fatalError("can't find TalentDetailViewController")
        }
        
        vc.userModel = userModels
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapTransfer() {
        tabBarController?.tabBar.isHidden = true
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "TransferSeedVC") as? TransferSeedVC else {
            
            fatalError("can't find TransferSeedVC")
        }
//        navigationController?.pushViewController(vc, animated: true)
//        vc?.hidesBottomBarWhenPushed = true
        present(vc, animated: true, completion: nil)
        tabBarController?.tabBar.isHidden = true
    }
 
    
    func setup() {
        
        transferBtn.addTarget(self, action: #selector(didTapTransfer), for: .touchUpInside)
        talentBtn.addTarget(self, action: #selector(didTapTalent), for: .touchUpInside)
    }
    
    func setStyle() {
        
        view.backgroundColor = .white
        
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.backgroundColor = .gray
        let URL = userModels?.userAvatar
        userAvatar.kf.setImage(with: URL)
        
        nameLabel.text = "Name:"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        userName.text = userModels?.name
        userName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        seedLabel.text = "Seeds"
        seedLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        seedValueLabel.font = UIFont.systemFont(ofSize: 56, weight: .bold)
        seedValueLabel.text = String(describing: userModels?.seedValue ?? 0)
        
        seedIcon.image = UIImage(named: "Lychee")
        
        barcodeUIImage.backgroundColor = .gray
//        barcodeUIImage.image = generateBarcode(userID: userID)
        let image = generateBarcode(userID: userID)
        let targetSize = CGSize(width: view.frame.width, height: 400 )
        let scaledImage = image!.scalePreservingAspectRatio(
            targetSize: targetSize
        )
        barcodeUIImage.image = scaledImage
        barcodeUIImage.lkBorderWidth = 1
        barcodeUIImage.lkBorderColor = .gray
        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.strokeColor = UIColor.lightGray.cgColor
//        shapeLayer.lineWidth = 1
//        let starPoint = CGPoint(x: 0, y: barcodeUIImage.bounds.maxY)
//        let endPoint = CGPoint(x: barcodeUIImage.bounds.maxX, y: barcodeUIImage.bounds.maxY)
//        let path = CGMutablePath()
//        path.addLines(between: [starPoint, endPoint])
//        shapeLayer.path = path
//        barcodeUIImage.layer.addSublayer(shapeLayer)
        
        userIDLabel.text = userModels?.userID
        userIDLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        transferBtn.lkCornerRadius = transferBtn.frame.width / 2
        talentBtn.lkCornerRadius = transferBtn.frame.width / 2
        boardBtn.lkCornerRadius = transferBtn.frame.width / 2
        
        transferBtn.setTitle("Transfer", for: .normal)
        transferBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        transferBtn.backgroundColor = .gray
        
        talentBtn.setTitle("Talent", for: .normal)
        talentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        talentBtn.backgroundColor = .gray
        
        boardBtn.setTitle("Board", for: .normal)
        boardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        boardBtn.backgroundColor = .gray
        
        nameStack.axis = .horizontal
        nameStack.spacing = 6
        
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
    }
    
    func layout() {
        
        view.addSubview(userAvatar)
        view.addSubview(nameStack)
        view.addSubview(seedLabel)
        
        view.addSubview(seedValueLabel)
        view.addSubview(seedIcon)
        
        view.addSubview(barcodeUIImage)
        view.addSubview(userIDLabel)
        view.addSubview(buttonStack)
        
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(userName)
        
        buttonStack.addArrangedSubview(transferBtn)
        buttonStack.addArrangedSubview(talentBtn)
        buttonStack.addArrangedSubview(boardBtn)
        
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        seedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        seedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        seedIcon.translatesAutoresizingMaskIntoConstraints = false
        barcodeUIImage.translatesAutoresizingMaskIntoConstraints = false
        userIDLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            userAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userAvatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userAvatar.widthAnchor.constraint(equalToConstant: 140),
            userAvatar.heightAnchor.constraint(equalTo: userAvatar.widthAnchor),
            
            nameStack.leadingAnchor.constraint(equalTo: barcodeUIImage.leadingAnchor),
            nameStack.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 60),
            
            seedLabel.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            seedLabel.topAnchor.constraint(equalTo: nameStack.bottomAnchor, constant: 8),
            
            seedValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seedValueLabel.heightAnchor.constraint(equalToConstant: 50),
            seedValueLabel.topAnchor.constraint(equalTo: seedLabel.bottomAnchor, constant: 8),
            
            seedIcon.trailingAnchor.constraint(equalTo: barcodeUIImage.trailingAnchor),
            seedIcon.widthAnchor.constraint(equalToConstant: 30),
            seedIcon.heightAnchor.constraint(equalTo: seedIcon.widthAnchor),
            seedIcon.bottomAnchor.constraint(equalTo: seedValueLabel.bottomAnchor),
            
            barcodeUIImage.topAnchor.constraint(equalTo: seedValueLabel.bottomAnchor, constant: 60),
            barcodeUIImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barcodeUIImage.widthAnchor.constraint(equalToConstant: view.frame.width - 100 ),
            barcodeUIImage.heightAnchor.constraint(equalToConstant: 70),
            
            userIDLabel.topAnchor.constraint(equalTo: barcodeUIImage.bottomAnchor, constant: 4),
            userIDLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userIDLabel.heightAnchor.constraint(equalToConstant: 16),
            
            buttonStack.widthAnchor.constraint(equalTo: barcodeUIImage.widthAnchor),
            buttonStack.topAnchor.constraint(equalTo: userIDLabel.bottomAnchor, constant: 40),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 60),
            
            transferBtn.widthAnchor.constraint(equalToConstant: 60),
            talentBtn.widthAnchor.constraint(equalToConstant: 60),
            boardBtn.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}
