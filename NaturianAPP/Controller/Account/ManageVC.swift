//
//  ManageVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/9.
//

import UIKit

class ManageVC: UIViewController {
    
    let closeButton = UIButton()
    let titleLB = UILabel()
    let blackView = UIView()
    
    let logoutBtn = UIButton()
    let delelteAccountBtn = UIButton()
    let unBlockBtn = UIButton()
    
    let logoutLB = UILabel()
    let delelteAccountLB = UILabel()
    let unBlockLB = UILabel()
    
    let accountLB = UILabel()
    let userInfoLB = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: false)
    }
    
    func setup() {
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
    }
    
    func style() {
        closeButton.setImage(UIImage(named: "back_gray"), for: .normal)
        
        titleLB.text = "Set Up"
        titleLB.font = UIFont(name: Roboto.bold.rawValue, size: 20)
        
        blackView.backgroundColor = .NaturianColor.lightGray
        blackView.lkBorderColor = .NaturianColor.darkGray
        blackView.lkBorderWidth = 1
        
        accountLB.textColor = .NaturianColor.navigationGray
        accountLB.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        accountLB.text = "Account Setting"
        
        userInfoLB.textColor = .NaturianColor.navigationGray
        userInfoLB.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        userInfoLB.text = "User Info"

        logoutLB.textColor = .NaturianColor.darkGray
        logoutLB.text = "Log Out"
        logoutLB.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        
        logoutBtn.setImage(UIImage(named: "accountGo"), for: .normal)
        logoutBtn.backgroundColor = .white
        logoutBtn.lkBorderWidth = 1
        logoutBtn.lkBorderColor = .NaturianColor.darkGray
        logoutBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        logoutBtn.contentHorizontalAlignment = .trailing
        
        delelteAccountLB.text = "Delete Account"
        delelteAccountLB.textColor = .NaturianColor.darkGray
        delelteAccountLB.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        delelteAccountBtn.setImage(UIImage(named: "accountGo"), for: .normal)
        delelteAccountBtn.backgroundColor = .white
        delelteAccountBtn.lkBorderWidth = 1
        delelteAccountBtn.lkBorderColor = .NaturianColor.darkGray
        delelteAccountBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        delelteAccountBtn.contentHorizontalAlignment = .trailing
        
        unBlockLB.text = "Unblock Users"
        unBlockLB.textColor = .NaturianColor.darkGray
        unBlockLB.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        unBlockBtn.setImage(UIImage(named: "accountGo"), for: .normal)
        unBlockBtn.backgroundColor = .white
        unBlockBtn.lkBorderWidth = 1
        unBlockBtn.lkBorderColor = .NaturianColor.darkGray
        unBlockBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        unBlockBtn.contentHorizontalAlignment = .trailing
    }
    
    func layout() {
        
        view.addSubview(closeButton)
        view.addSubview(titleLB)
        view.addSubview(blackView)
        
        blackView.addSubview(accountLB)
        blackView.addSubview(logoutBtn)
        blackView.addSubview(delelteAccountBtn)
        blackView.addSubview(userInfoLB)
        blackView.addSubview(unBlockBtn)
        
        logoutBtn.addSubview(logoutLB)
        delelteAccountBtn.addSubview(delelteAccountLB)
        unBlockBtn.addSubview(unBlockLB)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        blackView.translatesAutoresizingMaskIntoConstraints = false
        
        accountLB.translatesAutoresizingMaskIntoConstraints = false
        
        logoutLB.translatesAutoresizingMaskIntoConstraints = false
        logoutBtn.translatesAutoresizingMaskIntoConstraints = false
        
        delelteAccountLB.translatesAutoresizingMaskIntoConstraints = false
        delelteAccountBtn.translatesAutoresizingMaskIntoConstraints = false

        userInfoLB.translatesAutoresizingMaskIntoConstraints = false
        unBlockLB.translatesAutoresizingMaskIntoConstraints = false
        unBlockBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            titleLB.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 9),
            titleLB.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            blackView.topAnchor.constraint(equalTo: titleLB.bottomAnchor, constant: 12),
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            accountLB.topAnchor.constraint(equalTo: blackView.topAnchor, constant: 30),
            accountLB.leadingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            
            logoutLB.centerYAnchor.constraint(equalTo: logoutBtn.centerYAnchor),
            logoutLB.leadingAnchor.constraint(equalTo: accountLB.leadingAnchor),
            
            logoutBtn.topAnchor.constraint(equalTo: accountLB.bottomAnchor, constant: 6),
            logoutBtn.leadingAnchor.constraint(equalTo: blackView.leadingAnchor),
            logoutBtn.trailingAnchor.constraint(equalTo: blackView.trailingAnchor),
            logoutBtn.heightAnchor.constraint(equalToConstant: 58),
            
            delelteAccountLB.centerYAnchor.constraint(equalTo: delelteAccountBtn.centerYAnchor),
            delelteAccountLB.leadingAnchor.constraint(equalTo: accountLB.leadingAnchor),
            
            delelteAccountBtn.topAnchor.constraint(equalTo: logoutBtn.bottomAnchor, constant: -1),
            delelteAccountBtn.leadingAnchor.constraint(equalTo: blackView.leadingAnchor),
            delelteAccountBtn.trailingAnchor.constraint(equalTo: blackView.trailingAnchor),
            delelteAccountBtn.heightAnchor.constraint(equalToConstant: 58),
            
            userInfoLB.topAnchor.constraint(equalTo: delelteAccountBtn.bottomAnchor, constant: 24),
            userInfoLB.leadingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            
            unBlockLB.centerYAnchor.constraint(equalTo: unBlockBtn.centerYAnchor),
            unBlockLB.leadingAnchor.constraint(equalTo: accountLB.leadingAnchor),
            
            unBlockBtn.topAnchor.constraint(equalTo: userInfoLB.bottomAnchor, constant: 6),
            unBlockBtn.leadingAnchor.constraint(equalTo: blackView.leadingAnchor),
            unBlockBtn.trailingAnchor.constraint(equalTo: blackView.trailingAnchor),
            unBlockBtn.heightAnchor.constraint(equalToConstant: 58)
            
        ])
        
    }
    
}
