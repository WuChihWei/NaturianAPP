//
//  AccountViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit
import Kingfisher
import FirebaseAuth
import AuthenticationServices

protocol AccountVCDelegate: AnyObject {
    func sendAccountInfo(userModel: UserModel?)
}

class AccountViewController: UIViewController {
    
    weak var accountDelegate: AccountVCDelegate?
    
    var signinVC = SignInViewController()
    var userManager = UserManager()
    var userFirebaseManager = UserFirebaseManager()
    
//    let userID = Auth.auth().currentUser?.uid
        let userID = "2"
    var userModels: UserModel!
    let backgroundView = UIView()
    
    let signOutLBBTN = UIButton()
    let signOutButton = UIButton()
    let signOutStack = UIStackView()
    let deletetButton = UIButton()
    
    let userAvatar = UIImageView()
    let editImageBtn = UIButton()
    let blackLine = UIView()
    let circleR = UIView()
    let circleL = UIView()

    let naturianLB = UILabel()
    let utopiaLB = UILabel()
    let passeportLB = UILabel()
    
    let naturianInfoLB = UILabel()
    let userName = UILabel()
    let userGender = UILabel()
    let userNation = UILabel()
    
    let naturianStack = UIStackView()
    let naturianInfoStack = UIStackView()
    
    let seedLabel = UILabel()
    var seedValueLabel = UILabel()
    let seedIcon = UIImageView()
    
    let qrUIImage = UIImageView()
    
    let transferBtn = UIButton()
    let talentBtn = UIButton()
    //    let boardBtn = UIButton()
    
    let buttonStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.tintColor = .darkGray
        
        self.tabBarController?.tabBar.unselectedItemTintColor = .NaturianColor.lightGray
        setup()
        setStyle()
        layout()
        print(userID)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        userState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        
        view.layoutIfNeeded()
        backgroundView.layoutIfNeeded()
        qrUIImage.clipsToBounds = true
        userAvatar.clipsToBounds = true
        qrUIImage.contentMode = .scaleToFill
        userAvatar.lkCornerRadius = userAvatar.bounds.width / 2
        userAvatar.lkBorderColor = .NaturianColor.treatmentGreen
        userAvatar.lkBorderWidth = 4
        
        blackLine.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width - 10).isActive = true
        seedValueLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor,
                                               constant: -(backgroundView.bounds.height / 4)).isActive = true
        
        circleL.lkCornerRadius = circleL.bounds.width / 2
        circleR.lkCornerRadius = circleR.bounds.width / 2
        
        userAvatar.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: backgroundView.bounds.height / 4 - 73 ).isActive = true
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    func userState() {
            
//        guard let userID = Auth.auth().currentUser?.uid else {return}
        
            userFirebaseManager.fetchUserData(userID: userID) { [weak self] result in
                
                switch result {
                    
                case .success(let userModel):
                    
                    self?.userModels = userModel
                    
                    print(self?.userModels ?? "")
                    DispatchQueue.main.async {
                        
                        self?.viewDidLoad()
                    }
                    
                case .failure:
                    print("can't fetch data")
                }
            }
        }
    
    // delete accout
    @objc func deleteuser() {
            let alert  = UIAlertController(title: "Delete Account", message: "Are you sure?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "YES", style: .destructive) { (_) in
                self.deleteAccount()
            }
            let noAction = UIAlertAction(title: "Cancel", style: .cancel)

            alert.addAction(noAction)
            alert.addAction(yesAction)

            present(alert, animated: true, completion: nil)
        }

        func deleteAccount() {
            userFirebaseManager.deleteAccount()
//            let porfilVC = ProfileVC()
//            porfilVC.modalPresentationStyle = .overFullScreen
//            navigationController?.present(porfilVC, animated: true, completion: nil)
        }
    
    // logout accout
    @objc func tapToLogout() {
                let controller = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "Comfirm", style: .default) { _ in

                    do {

                        try Auth.auth().signOut()
                        self.navigationController?.popToRootViewController(animated: true)
                        print("sign outtttt")

                    } catch let signOutError as NSError {

                       print("Error signing out: (signOutError)")

                    }
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                controller.addAction(okAction)

                controller.addAction(cancelAction)

                present(controller, animated: true, completion: nil)
            }
    
    @objc func didTapTalent() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "TalentManageViewController") as? MyTalentManageVC else {
            
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
        vc.currentUserModels = self.userModels
        
        present(vc, animated: true, completion: nil)
        //        tabBarController?.tabBar.isHidden = true
    }
    
    func setup() {
     
        deletetButton.addTarget(self, action: #selector(deleteuser), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(tapToLogout), for: .touchUpInside)
        signOutLBBTN.addTarget(self, action: #selector(tapToLogout), for: .touchUpInside)
        transferBtn.addTarget(self, action: #selector(didTapTransfer), for: .touchUpInside)
        talentBtn.addTarget(self, action: #selector(didTapTalent), for: .touchUpInside)
    }
    
    func setStyle() {
        
        view.backgroundColor = UIColor.NaturianColor.navigationGray
        signOutLBBTN.setTitle("SIGN OUT", for: .normal)
        signOutLBBTN.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        signOutLBBTN.setTitleColor(.white, for: .normal)
        signOutButton.setImage(UIImage(named: "leave_white"), for: .normal)
//        signOutButton.backgroundColor = .blue
        
        deletetButton.titleLabel?.font =  UIFont(name: Roboto.bold.rawValue, size: 12)
        deletetButton.setTitle("X DELETE ACCOUNT X", for: .normal)
        deletetButton.setTitleColor(.white, for: .normal)
//        deletetButton.backgroundColor = .blue
        
        backgroundView.lkCornerRadius = 20
        backgroundView.backgroundColor = .white
        blackLine.backgroundColor = .NaturianColor.navigationGray
        circleL.backgroundColor = .NaturianColor.navigationGray
        circleR.backgroundColor = .NaturianColor.navigationGray

        userAvatar.contentMode = .scaleAspectFill
        userAvatar.backgroundColor = .NaturianColor.lightGray
//        let url = URL(string: "\(userModels?.userAvatar ?? "")")
        userAvatar.kf.setImage(with: userModels?.userAvatar)
        
        naturianLB.text = "NATURIAN"
        naturianLB.font = UIFont(name: Roboto.black.rawValue, size: 18)
        naturianLB.textColor = .NaturianColor.darkGray
        utopiaLB.text = "UTOPIA"
        utopiaLB.font = UIFont(name: Roboto.bold.rawValue, size: 18)
        utopiaLB.textColor = .NaturianColor.darkGray
        passeportLB.text = "PASSPORT"
        passeportLB.font = UIFont(name: Roboto.bold.rawValue, size: 18)
        passeportLB.textColor = .NaturianColor.darkGray

        seedLabel.text = "Seeds"
        seedLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        seedValueLabel.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        seedValueLabel.text = String(describing: userModels?.seedValue ?? 0)
        seedValueLabel.textColor = .NaturianColor.darkGray
   
        naturianInfoLB.text = "NATURIAN INFO"
        naturianInfoLB.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        naturianInfoLB.textColor = .NaturianColor.darkGray
        
        userName.text = "Name: \(String(describing: userModels?.name ?? ""))"
        userName.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        userName.textColor = .NaturianColor.darkGray
        
        userGender.text = "Gender: \(String(describing: userModels?.gender ?? ""))"
        userGender.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        userGender.textColor = .NaturianColor.darkGray
        
        userNation.text = "Nation: Nature"
        userNation.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        userNation.textColor = .NaturianColor.darkGray
        
        seedIcon.image = UIImage(named: "seed")
        
        qrUIImage.backgroundColor = .blue
        qrUIImage.image = generateQRCode(from: userID )
        
        transferBtn.setImage(UIImage(named: "transferButton"), for: .normal)
        
        talentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        talentBtn.setImage(UIImage(named: "talentButton"), for: .normal)
        
        naturianStack.axis = .vertical
        naturianStack.spacing = 0
        
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
        
        signOutStack.axis = .horizontal
        signOutStack.alignment = .center
        signOutStack.spacing = 3
        
        naturianInfoStack.axis = .vertical
        naturianInfoStack.alignment = .leading
        
    }
    
    func layout() {
        
        view.addSubview(backgroundView)
        
        view.addSubview(signOutStack)
        view.addSubview(deletetButton)
        
        signOutStack.addArrangedSubview(signOutLBBTN)
        signOutStack.addArrangedSubview(signOutButton)

        backgroundView.addSubview(naturianStack)
        backgroundView.addSubview(blackLine)
        backgroundView.addSubview(userAvatar)
        backgroundView.addSubview(circleL)
        backgroundView.addSubview(circleR)
        
        backgroundView.addSubview(seedValueLabel)
        backgroundView.addSubview(seedIcon)
        
        backgroundView.addSubview(qrUIImage)
        backgroundView.addSubview(buttonStack)
        
        backgroundView.addSubview(transferBtn)
        
        backgroundView.addSubview(talentBtn)
        naturianStack.addArrangedSubview(naturianLB)
        naturianStack.addArrangedSubview(utopiaLB)
        naturianStack.addArrangedSubview(passeportLB)
        
        naturianInfoStack.addArrangedSubview(userName)
        naturianInfoStack.addArrangedSubview(userGender)
        naturianInfoStack.addArrangedSubview(userNation)

        backgroundView.addSubview(naturianInfoLB)
        backgroundView.addSubview(naturianInfoStack)
      
        naturianInfoStack.translatesAutoresizingMaskIntoConstraints = false
        naturianInfoLB.translatesAutoresizingMaskIntoConstraints = false
        naturianStack.translatesAutoresizingMaskIntoConstraints = false
        signOutStack.translatesAutoresizingMaskIntoConstraints = false
        deletetButton.translatesAutoresizingMaskIntoConstraints = false
        
        circleL.translatesAutoresizingMaskIntoConstraints = false
        circleR.translatesAutoresizingMaskIntoConstraints = false

        blackLine.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        naturianStack.translatesAutoresizingMaskIntoConstraints = false
        
        seedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        seedIcon.translatesAutoresizingMaskIntoConstraints = false
        qrUIImage.translatesAutoresizingMaskIntoConstraints = false
        
        talentBtn.translatesAutoresizingMaskIntoConstraints = false
        transferBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            signOutStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 0),
            signOutStack.bottomAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -5),
            
            signOutButton.heightAnchor.constraint(equalToConstant: 18),
            signOutButton.widthAnchor.constraint(equalToConstant: 18),
            
            deletetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deletetButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 8),
            
            naturianStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            naturianStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            naturianStack.heightAnchor.constraint(equalToConstant: 54),
            naturianLB.heightAnchor.constraint(equalToConstant: 18),
            utopiaLB.heightAnchor.constraint(equalToConstant: 18),
            passeportLB.heightAnchor.constraint(equalToConstant: 18),
            
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            blackLine.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            blackLine.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            blackLine.heightAnchor.constraint(equalToConstant: 2),
            
            circleL.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            circleL.widthAnchor.constraint(equalToConstant: 18),
            circleL.heightAnchor.constraint(equalToConstant: 18),
            circleL.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: -9),
            
            circleR.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            circleR.widthAnchor.constraint(equalToConstant: 18),
            circleR.heightAnchor.constraint(equalToConstant: 18),
            circleR.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 9),
            
            talentBtn.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            talentBtn.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -36),
            talentBtn.widthAnchor.constraint(equalToConstant: 58),
            talentBtn.heightAnchor.constraint(equalToConstant: 58),
            
            userAvatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userAvatar.widthAnchor.constraint(equalToConstant: 146),
            userAvatar.heightAnchor.constraint(equalToConstant: 146),
            
            seedValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seedValueLabel.heightAnchor.constraint(equalToConstant: 58),
            
            seedIcon.trailingAnchor.constraint(equalTo: seedValueLabel.leadingAnchor, constant: -6),
            seedIcon.widthAnchor.constraint(equalToConstant: 20),
            seedIcon.heightAnchor.constraint(equalToConstant: 20),
            seedIcon.topAnchor.constraint(equalTo: seedValueLabel.topAnchor, constant: -4),
            
            qrUIImage.widthAnchor.constraint(equalToConstant: 88),
            qrUIImage.heightAnchor.constraint(equalToConstant: 88),
            qrUIImage.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            qrUIImage.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            
            transferBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transferBtn.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            transferBtn.widthAnchor.constraint(equalToConstant: 54),
            transferBtn.heightAnchor.constraint(equalToConstant: 54),
            
            naturianInfoStack.bottomAnchor.constraint(equalTo: qrUIImage.bottomAnchor),
            naturianInfoStack.leadingAnchor.constraint(equalTo: naturianStack.leadingAnchor),
            naturianInfoLB.bottomAnchor.constraint(equalTo: naturianInfoStack.topAnchor, constant: -6),
            naturianInfoLB.leadingAnchor.constraint(equalTo: naturianInfoStack.leadingAnchor),
            
            userName.heightAnchor.constraint(equalToConstant: 14),
            userGender.heightAnchor.constraint(equalToConstant: 14),
            userNation.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}
