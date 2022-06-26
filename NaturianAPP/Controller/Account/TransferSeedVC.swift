//
//  TransferSeedVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/24.
//

import UIKit

class TransferSeedVC: UIViewController {
    
    var scannerVC = ScannerVC()
    
    var backButton = UIButton()
    var scanBarButton = UIButton()
    let transferToLabel = UILabel()
    
    let nameLabel = UILabel()
    let iDLabel = UILabel()
    
    var userNameLabel = UILabel()
    var userIDLabel = UILabel()
    
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
    
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func scanBarTapped() {
        //        navigationController?.dismiss(animated: true)
        //        self.dismiss(animated: true, completion: nil)
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ScannerVC") as? ScannerVC else {
            
            fatalError("can't find ScannerVC")
        }
        vc.sendBarcodeDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func setup() {
        scanBarButton.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func didDismiss() {
        dismiss(animated: true)
    }
    
    func style() {
        //
        backButton.setImage(UIImage(named: "dismiss"), for: .normal)
        backButton.setTitle("", for: .normal)
        
        scanBarButton.setImage(UIImage(named: "scan"), for: .normal)
        scanBarButton.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
        scanBarButton.setTitle("", for: .normal)
        
        transferToLabel.text = "Transfer To"
        transferToLabel.textColor = UIColor.NaturianColor.treatmentGreen
        transferToLabel.textAlignment = .center
        transferToLabel.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        
        nameLabel.text = "User Name :"
        nameLabel.font = UIFont(name: Roboto.bold.rawValue, size: 24)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.NaturianColor.darkGray
        
        userNameLabel.text = "David"
        userNameLabel.font = UIFont(name: Roboto.bold.rawValue, size: 24)
        userNameLabel.textAlignment = .right
        userNameLabel.textColor = UIColor.NaturianColor.darkGray
        
        iDLabel.text = "User ID :"
        iDLabel.font = UIFont(name: Roboto.bold.rawValue, size: 24)
        iDLabel.textAlignment = .left
        iDLabel.textColor = UIColor.NaturianColor.darkGray
        
        userIDLabel.text = "0"
        userIDLabel.font = UIFont.init(name: Roboto.bold.rawValue, size: 24)
        userIDLabel.textAlignment = .right
        userIDLabel.textColor = UIColor.NaturianColor.darkGray
        
        seedTextField.placeholder = "0"
        seedTextField.addPadding(.right(12))
        seedTextField.textAlignment = .right
        seedTextField.textColor = UIColor.NaturianColor.treatmentGreen
        seedTextField.font = UIFont.init(name: Roboto.bold.rawValue, size: 48)
        seedTextField.backgroundColor = .white
        
        remainSeedLabel.text = "Remaining Seeds :"
        remainSeedLabel.font = UIFont.init(name: Roboto.medium.rawValue, size: 16)
        remainSeedLabel.textColor = UIColor.NaturianColor.darkGray
        remainSeedLabel.textAlignment = .left
        
        seedIcon.image = UIImage(named: "seed")
        
        remainSeedValue.text = "420"
        remainSeedValue.font = UIFont.init(name: Roboto.bold.rawValue, size: 48)
        remainSeedValue.textColor = UIColor.NaturianColor.darkGray
        
        tranferButton.setTitle("Transfer", for: .normal)
        tranferButton.setTitleColor(.white, for: .normal)
        tranferButton.backgroundColor = UIColor.NaturianColor.treatmentGreen
        tranferButton.alpha = 0.8
        tranferButton.isEnabled = false
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
    //
    func layout() {
        //
        backButton.translatesAutoresizingMaskIntoConstraints = false
        //
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
        labelStack.addArrangedSubview(iDLabel)
        
        view.addSubview(userStack)
        userStack.addArrangedSubview(userNameLabel)
        userStack.addArrangedSubview(userIDLabel)
        
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
            iDLabel.heightAnchor.constraint(equalToConstant: 24),
            
            userStack.topAnchor.constraint(equalTo: labelStack.topAnchor),
            userStack.trailingAnchor.constraint(equalTo: scanBarButton.trailingAnchor),
            userIDLabel.heightAnchor.constraint(equalToConstant: 24),
            userNameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            seedTextField.leadingAnchor.constraint(equalTo: labelStack.leadingAnchor),
            seedTextField.trailingAnchor.constraint(equalTo: userStack.trailingAnchor),
            seedTextField.topAnchor.constraint(equalTo: userStack.bottomAnchor, constant: 40),
            seedTextField.heightAnchor.constraint(equalToConstant: 80),
            
            remainSeedLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            remainSeedLabel.topAnchor.constraint(equalTo: seedTextField.bottomAnchor, constant: 40),
            
            seedstack.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            seedstack.topAnchor.constraint(equalTo: remainSeedLabel.bottomAnchor, constant: 12),
            seedIcon.heightAnchor.constraint(equalToConstant: 48),
            seedIcon.widthAnchor.constraint(equalToConstant: 48),
            remainSeedValue.heightAnchor.constraint(equalToConstant: 48),
            
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
        
        self.userIDLabel.text = userID
    }
}
