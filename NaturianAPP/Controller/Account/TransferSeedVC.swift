//
//  TransferSeedVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/24.
//

import UIKit

class TransferSeedVC: UIViewController {
    
    var scanBarButton = UIButton()
    var scanTextField = UITextField()
    var scannerVC = ScannerVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBlue
        
        style()
        setup()
        layout()
    }
    
    @objc func scanBarTapped() {
//        navigationController?.dismiss(animated: true)
//        self.dismiss(animated: true, completion: nil)
        dismiss(animated: true)
    }
    
    func setup() {
        scanBarButton.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
    }
    
    func style() {
        
        scanBarButton.backgroundColor = UIColor.systemYellow
        scanBarButton.setTitle("Scan Bar Code", for: .normal)
        scanBarButton.setTitleColor(UIColor.white, for: .normal)
        scanBarButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 25)
        scanBarButton.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
        
//        scanTextField.text = "Default"
        scanTextField.textAlignment = .center
        scanTextField.textColor = UIColor.white
        scanTextField.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
    }
    
    func layout() {
        
        view.addSubview(scanBarButton)
        view.addSubview(scanTextField)
        
        scanBarButton.translatesAutoresizingMaskIntoConstraints = false
        scanTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
        
            scanTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scanTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanTextField.widthAnchor.constraint(equalToConstant: 140),
            scanTextField.heightAnchor.constraint(equalToConstant: 30),
            
            scanBarButton.topAnchor.constraint(equalTo: scanTextField.bottomAnchor, constant: 20),
            scanBarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
