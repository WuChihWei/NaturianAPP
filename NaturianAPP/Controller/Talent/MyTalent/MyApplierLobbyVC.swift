//
//  TalentAppliersViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import FirebaseAuth
import LZViewPager

class MyApplierLobbyVC: UIViewController {
    
    var userModel: UserModel!
    let viewPagers =  LZViewPager()
    let closeButton = UIButton()
    let mailButton = UIButton()
    var talentArticleID: String?
    var didSeletectApplierIDs: [String] = []
    var talentArticle: TalentArticle!
    var appliedIDs: [UserModel] = []
    var acceptIDs: [UserModel] = []
    
//    private let grayView = UIView()
    private var subControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        style()
        setUp()
        layout()
        viewPagerPoperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    func viewPagerPoperties() {
        viewPagers.delegate = self
        viewPagers.dataSource = self
        viewPagers.hostController = self
        
        guard let vc1 = UIStoryboard(name: "Main",
                                     bundle: nil).instantiateViewController(withIdentifier: "AllMyAppliersVC") as? AllMyAppliersVC else {return}
        
        vc1.talentArticleID = self.talentArticleID
        vc1.didSeletectApplierIDs = self.didSeletectApplierIDs
        vc1.didSeletectDetails = self.talentArticle
        vc1.delegate = self
        
        guard let vc2 = UIStoryboard(name: "Main",
                                     bundle: nil).instantiateViewController(withIdentifier: "MyAppliersVC") as? MyAppliersVC else {return}
        
        vc2.talentArticleID = self.talentArticleID
        vc2.didSeletectApplierIDs = self.didSeletectApplierIDs
        vc2.didSeletectDetails = self.talentArticle
        vc2.appliedIDs = self.appliedIDs
        vc2.viewWillAppear(true)
        
        guard let vc3 = UIStoryboard(name: "Main",
                                     bundle: nil).instantiateViewController(withIdentifier: "MyAcceptedVC") as? MyAcceptedVC else {return}
        
        vc3.talentArticleID = self.talentArticleID
        vc3.didSeletectApplierIDs = self.didSeletectApplierIDs
        vc3.didSeletectDetails = self.talentArticle
        vc3.acceptIDs = self.acceptIDs
        vc3.viewWillAppear(true)

        subControllers = [vc1, vc2, vc3]
        
        vc1.title = "All"
        vc2.title = "Applied"
        vc3.title = "Accepted"

        viewPagers.reload()
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: false)
    }
    
    func setUp() {
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
    }
    
    func style() {
        // backTabBar
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        closeButton.setImage(UIImage(named: "back_gray"), for: .normal)
        mailButton.setImage(UIImage(named: "mail_gray"), for: .normal)

    }
    
    func layout() {
        
        view.addSubview(mailButton)
        view.addSubview(closeButton)
        view.addSubview(viewPagers)
        viewPagers.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        mailButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mailButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            mailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mailButton.heightAnchor.constraint(equalToConstant: 34),
            mailButton.widthAnchor.constraint(equalToConstant: 34),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            viewPagers.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 4),
            viewPagers.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPagers.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewPagers.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension MyApplierLobbyVC: LZViewPagerDelegate {
    
}

extension MyApplierLobbyVC: LZViewPagerDataSource {
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(.NaturianColor.lightGray, for: .normal)
        button.setTitleColor(.NaturianColor.darkGray, for: .selected)
        button.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        button.backgroundColor = .white
        
//        button.addSubview(grayView)
        return button
    }
    
    func colorForIndicator(at index: Int) -> UIColor {
        return .NaturianColor.darkGray
    }
    
    func heightForIndicator() -> CGFloat {
        return 6
    }
    
    func heightForHeader() -> CGFloat {
        return 50
    }
    func backgroundColorForHeader() -> UIColor {
        return .NaturianColor.navigationGray
    }
    
    func didSelectButton(at index: Int) {
        
    }
}

extension MyApplierLobbyVC: SendUserStateDelegate {
    func applier(appliedIDs: [UserModel]) {
        self.appliedIDs = appliedIDs
    }
    
    func accept(acceptIDs: [UserModel]) {
        self.acceptIDs = acceptIDs
    }
}
