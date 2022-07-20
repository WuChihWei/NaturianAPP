//
//  TransferSeedVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/24.
//

import UIKit
import FirebaseAuth

class TransferSeedVC: UIViewController, UITextFieldDelegate {
    
    var scannerVC = ScannerVC()
    var userFirebaseManager = UserManager()
    var otherUserModels: UserModel!
    let userID = Auth.auth().currentUser?.uid
//        let userID = "2"
    var userModels: UserModel!

    var backButton = UIButton()
    var scanBarButton = UIButton()
    let transferToLabel = UILabel()
    
    let nameLabel = UILabel()
    let userNameLB = UILabel()
    
    var userNameLabel = UILabel()
    var findOtherNameLB = UILabel()
    
    var remainSeedLabel = UILabel()
    var seedTextField = UITextField()
    
    var seedIcon = UIImageView()
    var remainSeedValue = UILabel()
    
    var tranferButton = UIButton()
    let cancelButton = UIButton()
    
    let labelStack = UIStackView()
    let userStack = UIStackView()
    let seedstack = UIStackView()
    let actStack = UIStackView()
    
    var otherSeedValue: Int = 0
    var transferValue: Int = 0
    
    var remainValue: Int = 0
        
//        didSet {
//            
//            remainSeedValue.text = "\(String(describing: remainValue))"
//            print(remainValue)
//        }
//    }
    
//    var userID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seedTextField.delegate = self
        tabBarController?.tabBar.isHidden = true
        
        view.backgroundColor = UIColor.NaturianColor.lightGray
        
        style()
        setup()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        
        view.layoutIfNeeded()
        seedTextField.clipsToBounds = true
        tranferButton.clipsToBounds = true
        
        seedTextField.lkCornerRadius = 10
        seedTextField.lkBorderColor = UIColor.NaturianColor.darkGray
        seedTextField.lkBorderWidth = 0.8
        tranferButton.lkCornerRadius = tranferButton.bounds.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        userState()
        tabBarController?.tabBar.isHidden = true
    }
    
    func userState() {
        
        userFirebaseManager.fetchUserData(userID: userID ?? "") { [weak self] result in
                
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
    
    @objc func updateSeedValue() {
        
        userFirebaseManager.updateUserSeeds(uid: otherUserModels?.userID ?? "",
                                       seedValue: otherSeedValue) { [weak self] result in
            switch result {
            case .success:
                
               print("success")
            case .failure:
                print("can't fetch data")
            }
        }
        
        userFirebaseManager.updateUserSeeds(uid: self.userID ?? "", seedValue: self.remainValue ?? 0) { [weak self] result in
            switch result {
            case .success:
                
                self?.dismiss(animated: true)
            case .failure:
                print("can't fetch data")
            }
        }
        

    }
    
    @objc func scanBarTapped() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ScannerVC") as? ScannerVC else {
            
            fatalError("can't find ScannerVC")
        }
        vc.sendBarcodeDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didDismiss() {
        navigationController?.popViewController(animated: false)
        dismiss(animated: true)
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        transferValue = Int("\(seedTextField.text!)") ?? 0
        
        remainValue = (userModels?.seedValue ?? 0) - transferValue
        otherSeedValue = (otherUserModels?.seedValue ?? 0) + transferValue
        
        if remainValue < 0 {
            
            let alertController = UIAlertController(
                title: "Insufficient Balance",
                message: "Please Reset The Seed Value",
                preferredStyle: .alert)
            
            // 建立[確認]按鈕
            let okAction = UIAlertAction(
                title: "Comfirm",
                style: .destructive,
                handler: { (_: UIAlertAction!) -> Void in self.seedTextField.text = "0"
                })
            
            alertController.addAction(okAction)
            
            self.present(
                alertController,
                animated: true,
                completion: nil)
            
        } else {
            
            remainSeedValue.text = "\(String(describing: remainValue))"
        }
    }
    
    func setup() {
        
        tranferButton.addTarget(self, action: #selector(updateSeedValue), for: .touchUpInside)
        scanBarButton.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        navigationController?.navigationBar.isHidden = true
        seedTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
    }
    
    func style() {
        //
        backButton.setImage(UIImage(named: "dismiss"), for: .normal)
        
        scanBarButton.setImage(UIImage(named: "scan"), for: .normal)
        scanBarButton.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
        scanBarButton.setTitle("", for: .normal)
        
        transferToLabel.text = "Transfer To"
        transferToLabel.textColor = UIColor.NaturianColor.treatmentGreen
        transferToLabel.textAlignment = .center
        transferToLabel.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        
        nameLabel.text = "NATURIAN"
        nameLabel.font = UIFont(name: Roboto.bold.rawValue, size: 24)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.NaturianColor.navigationGray
        
        userNameLB.text = "User Name :"
        userNameLB.font = UIFont(name: Roboto.bold.rawValue, size: 24)
        userNameLB.textAlignment = .left
        userNameLB.textColor = UIColor.NaturianColor.darkGray
        
        findOtherNameLB.text = "\(otherUserModels?.name ?? "")"
        findOtherNameLB.font = UIFont.init(name: Roboto.bold.rawValue, size: 24)
        findOtherNameLB.textAlignment = .right
        findOtherNameLB.textColor = UIColor.NaturianColor.darkGray
        
        seedTextField.keyboardType = .numberPad
        seedTextField.placeholder = "0"
        seedTextField.addPadding(.right(12))
        seedTextField.textAlignment = .right
        seedTextField.textColor = UIColor.NaturianColor.treatmentGreen
        seedTextField.font = UIFont.init(name: Roboto.bold.rawValue, size: 40)
        seedTextField.backgroundColor = .white
        
        remainSeedLabel.text = "Remaining Seeds :"
        remainSeedLabel.font = UIFont.init(name: Roboto.medium.rawValue, size: 16)
        remainSeedLabel.textColor = UIColor.NaturianColor.darkGray
        remainSeedLabel.textAlignment = .left
        
        seedIcon.image = UIImage(named: "seedgray")
        
        remainValue = userModels?.seedValue ?? 0
        remainSeedValue.text = "\(remainValue)"
        remainSeedValue.font = UIFont.init(name: Roboto.bold.rawValue, size: 40)
        remainSeedValue.textColor = UIColor.NaturianColor.darkGray
        
        tranferButton.setTitle("Transfer", for: .normal)
        tranferButton.setTitleColor(.white, for: .normal)
        tranferButton.backgroundColor = UIColor.NaturianColor.treatmentGreen
        tranferButton.alpha = 0.8
        //        tranferButton.isEnabled = false
        tranferButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.setTitleColor(UIColor.NaturianColor.treatmentGreen, for: .normal)
        
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 6
        
        userStack.axis = .vertical
        userStack.alignment = .trailing
        userStack.spacing = 6
        
        seedstack.axis = .horizontal
        seedstack.alignment = .center
        seedstack.alignment = .leading
        seedstack.spacing = 12
        
        actStack.axis = .horizontal
        actStack.alignment = .center
        actStack.spacing = 14
    }
    
    func layout() {
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        scanBarButton.translatesAutoresizingMaskIntoConstraints = false
        transferToLabel.translatesAutoresizingMaskIntoConstraints = false
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        userStack.translatesAutoresizingMaskIntoConstraints = false
        seedTextField.translatesAutoresizingMaskIntoConstraints = false
        remainSeedLabel.translatesAutoresizingMaskIntoConstraints = false
        seedstack.translatesAutoresizingMaskIntoConstraints = false
        actStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        view.addSubview(scanBarButton)
        view.addSubview(transferToLabel)
        
        view.addSubview(labelStack)
        labelStack.addArrangedSubview(nameLabel)
        labelStack.addArrangedSubview(userNameLB)
        
        view.addSubview(userStack)
        userStack.addArrangedSubview(userNameLabel)
        userStack.addArrangedSubview(findOtherNameLB)
        
        view.addSubview(seedTextField)
        
        view.addSubview(remainSeedLabel)
        
        view.addSubview(seedstack)
        seedstack.addArrangedSubview(seedIcon)
        seedstack.addArrangedSubview(remainSeedValue)
        
        view.addSubview(actStack)
        actStack.addArrangedSubview(tranferButton)
        actStack.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            //
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            
            scanBarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scanBarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            scanBarButton.widthAnchor.constraint(equalToConstant: 72),
            scanBarButton.heightAnchor.constraint(equalToConstant: 72),
            
            transferToLabel.centerXAnchor.constraint(equalTo: scanBarButton.centerXAnchor),
            transferToLabel.topAnchor.constraint(equalTo: scanBarButton.bottomAnchor, constant: 8),
            transferToLabel.heightAnchor.constraint(equalToConstant: 14),
            
            labelStack.topAnchor.constraint(equalTo: transferToLabel.bottomAnchor, constant: 40),
            labelStack.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            userNameLB.heightAnchor.constraint(equalToConstant: 24),
            
            userStack.topAnchor.constraint(equalTo: labelStack.topAnchor),
            userStack.trailingAnchor.constraint(equalTo: scanBarButton.trailingAnchor),
            findOtherNameLB.heightAnchor.constraint(equalToConstant: 24),
            userNameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            seedTextField.leadingAnchor.constraint(equalTo: labelStack.leadingAnchor),
            seedTextField.trailingAnchor.constraint(equalTo: userStack.trailingAnchor),
            seedTextField.topAnchor.constraint(equalTo: userStack.bottomAnchor, constant: 40),
            seedTextField.heightAnchor.constraint(equalToConstant: 80),
            
            remainSeedLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            remainSeedLabel.topAnchor.constraint(equalTo: seedTextField.bottomAnchor, constant: 40),
            
            seedstack.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            seedstack.topAnchor.constraint(equalTo: remainSeedLabel.bottomAnchor, constant: 12),
            seedIcon.heightAnchor.constraint(equalToConstant: 40),
            seedIcon.widthAnchor.constraint(equalToConstant: 40),
            remainSeedValue.heightAnchor.constraint(equalToConstant: 40),
            
            actStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            actStack.heightAnchor.constraint(equalToConstant: 48),
            tranferButton.widthAnchor.constraint(equalToConstant: 130),
            tranferButton.heightAnchor.constraint(equalToConstant: 48),
            cancelButton.widthAnchor.constraint(equalToConstant: 130),
            cancelButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

extension TransferSeedVC: SendBarcodeDelegate {
    func sendBarcodeValue(userID: String) {
        
        self.findOtherNameLB.text = userID
        userFirebaseManager.fetchUserData(userID: userID) {[weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.otherUserModels = userModel
                
                print(self?.otherUserModels ?? "")
                DispatchQueue.main.async {
                    
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
}
