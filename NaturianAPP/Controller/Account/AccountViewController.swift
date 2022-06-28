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
    var userManager = UserManager()
    var userModels: UserModel!
    let userID = "2"
    let backgroundView = UIView()
    
    let userAvatar = UIImageView()
    let editImageBtn = UIButton()
    let blackLine = UIView()
    
    let naturianLB = UILabel()
    let utopiaLB = UILabel()
    let passeportLB = UILabel()

    var userName = UILabel()
    let naturianStack = UIStackView()
    
    let seedLabel = UILabel()
    var seedValueLabel = UILabel()
    let seedIcon = UIImageView()
    
    let barcodeUIImage = UIImageView()
    let userIDLabel = UILabel()
    
    let transferBtn = UIButton()
    let talentBtn = UIButton()
//    let boardBtn = UIButton()
    
    let buttonStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.tintColor = .NaturianColor.treatmentGreen

        setup()
        setStyle()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        
        fetchUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        
        view.layoutIfNeeded()
        backgroundView.layoutIfNeeded()
        barcodeUIImage.clipsToBounds = true
        userAvatar.clipsToBounds = true
        barcodeUIImage.contentMode = .scaleAspectFill
        userAvatar.lkCornerRadius = userAvatar.bounds.width / 2
        userAvatar.lkBorderColor = .NaturianColor.treatmentGreen
        userAvatar.lkBorderWidth = 5
        
  }
    
    func generateBarcode(userID: String) -> UIImage? {
        
        let data = userID.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let filter = CIFilter.init(name: "CICode128BarcodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 12, y: 12)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
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
//        tabBarController?.tabBar.isHidden = true
    }
 
    func setup() {
        
        transferBtn.addTarget(self, action: #selector(didTapTransfer), for: .touchUpInside)
        talentBtn.addTarget(self, action: #selector(didTapTalent), for: .touchUpInside)
    }
    
    func setStyle() {
        
        view.backgroundColor = UIColor.NaturianColor.navigationGray
        
        backgroundView.lkCornerRadius = 20
        backgroundView.backgroundColor = .white
        blackLine.backgroundColor = .NaturianColor.navigationGray
        
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.backgroundColor = .gray
        let URL = userModels?.userAvatar
        userAvatar.kf.setImage(with: URL)
        
        naturianLB.text = "UTOPIA"
        naturianLB.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        utopiaLB.text = "NATURIAN"
        utopiaLB.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        passeportLB.text = "PASSPORT"
        passeportLB.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        
        userName.text = userModels?.name
        userName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        seedLabel.text = "Seeds"
        seedLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        seedValueLabel.font = UIFont.systemFont(ofSize: 56, weight: .bold)
        seedValueLabel.text = String(describing: userModels?.seedValue ?? 0)
        
        seedIcon.image = UIImage(named: "seed")
        
        barcodeUIImage.backgroundColor = .white
//        barcodeUIImage.image = generateBarcode(userID: userID)
        let image = generateBarcode(userID: userID)
        let targetSize = CGSize(width: view.frame.width, height: 200 )
        let scaledImage = image!.scalePreservingAspectRatio(
            targetSize: targetSize
        )
        barcodeUIImage.image = scaledImage

        userIDLabel.text = userModels?.userID
        userIDLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        transferBtn.setImage(UIImage(named: "transferButton"), for: .normal)
        transferBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    
        talentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        talentBtn.setImage(UIImage(named: "talentButton"), for: .normal)

        naturianStack.axis = .vertical
        naturianStack.distribution = .equalSpacing
        
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
    }
    
    func layout() {
        
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(naturianStack)
        backgroundView.addSubview(blackLine)
        backgroundView.addSubview(userAvatar)
        backgroundView.addSubview(userName)
        
        backgroundView.addSubview(seedValueLabel)
        backgroundView.addSubview(seedIcon)
        
        backgroundView.addSubview(barcodeUIImage)
        backgroundView.addSubview(userIDLabel)
        backgroundView.addSubview(buttonStack)
        
        backgroundView.addSubview(transferBtn)
        backgroundView.addSubview(talentBtn)
        
        naturianStack.addArrangedSubview(utopiaLB)
        naturianStack.addArrangedSubview(naturianLB)
        naturianStack.addArrangedSubview(passeportLB)
        
        blackLine.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        naturianStack.translatesAutoresizingMaskIntoConstraints = false
        
        seedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        seedIcon.translatesAutoresizingMaskIntoConstraints = false
        barcodeUIImage.translatesAutoresizingMaskIntoConstraints = false
        
        userIDLabel.translatesAutoresizingMaskIntoConstraints = false
//        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        talentBtn.translatesAutoresizingMaskIntoConstraints = false
        transferBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            naturianStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 18),
            naturianStack.bottomAnchor.constraint(equalTo: talentBtn.bottomAnchor),
            naturianStack.heightAnchor.constraint(equalToConstant: 46),
            naturianLB.heightAnchor.constraint(equalToConstant: 12),
            utopiaLB.heightAnchor.constraint(equalToConstant: 12),
            passeportLB.heightAnchor.constraint(equalToConstant: 12),
            
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            blackLine.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            blackLine.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            blackLine.heightAnchor.constraint(equalToConstant: 2),
            blackLine.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width - 10),
            
            talentBtn.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            talentBtn.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -36),
            talentBtn.widthAnchor.constraint(equalToConstant: 58),
            talentBtn.heightAnchor.constraint(equalToConstant: 58),
            
            userAvatar.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 80 ),
            userAvatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userAvatar.widthAnchor.constraint(equalToConstant: 155),
            userAvatar.heightAnchor.constraint(equalTo: userAvatar.widthAnchor),
            
//            userName.leadingAnchor.constraint(equalTo: blackLine.leadingAnchor),
            userName.heightAnchor.constraint(equalToConstant: 20),
            userName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userName.bottomAnchor.constraint(equalTo: blackLine.topAnchor, constant: -30),
//
            seedValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seedValueLabel.heightAnchor.constraint(equalToConstant: 64),
            seedValueLabel.bottomAnchor.constraint(equalTo: barcodeUIImage.topAnchor, constant: -24),
        
            seedIcon.leadingAnchor.constraint(equalTo: seedValueLabel.trailingAnchor, constant: 3),
            seedIcon.widthAnchor.constraint(equalToConstant: 14),
            seedIcon.heightAnchor.constraint(equalTo: seedIcon.widthAnchor),
            seedIcon.bottomAnchor.constraint(equalTo: seedValueLabel.bottomAnchor),
            
            barcodeUIImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barcodeUIImage.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width - 120 ),
            barcodeUIImage.heightAnchor.constraint(equalToConstant: 70),
            barcodeUIImage.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -((backgroundView.bounds.height/4) - (barcodeUIImage.frame.height))/2),
            
            userIDLabel.topAnchor.constraint(equalTo: barcodeUIImage.bottomAnchor, constant: 4),
            userIDLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userIDLabel.heightAnchor.constraint(equalToConstant: 14),
            
            transferBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transferBtn.widthAnchor.constraint(equalToConstant: 48),
            transferBtn.heightAnchor.constraint(equalToConstant: 48),
            transferBtn.topAnchor.constraint(equalTo: blackLine.bottomAnchor, constant: 30)
            
        ])
    }
}
