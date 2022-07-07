//
//  TalentManageViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit
import LZViewPager

class MyTalentManageVC: UIViewController {

    var userModel: UserModel!
    let viewPagers =  LZViewPager()
    let closeButton = UIButton()
    let mailButton = UIButton()

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
                                     bundle: nil).instantiateViewController(withIdentifier: "MyTalentViewController") as? MyTalentViewController else {return}
        
        guard let vc2 = UIStoryboard(name: "Main",
                                     bundle: nil).instantiateViewController(withIdentifier: "OtherTalentViewController") as? OtherTalentViewController else {return}
        
//        guard let vc3 = UIStoryboard(name: "Main",
//                                     bundle: nil).instantiateViewController(withIdentifier: "MyChatRoomVC") as? MyChatRoomVC else {return}
//        
        subControllers = [vc1, vc2]
        
        vc1.title = "My Talents"
        vc2.title = "My Wizards"
//        vc3.title = "Chat Room"

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

extension MyTalentManageVC: LZViewPagerDelegate {
    
}

extension MyTalentManageVC: LZViewPagerDataSource {
    
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
