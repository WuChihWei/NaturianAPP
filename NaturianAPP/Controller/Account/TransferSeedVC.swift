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
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true

        view.backgroundColor = UIColor.systemBlue
        
        style()
        setup()
        layout()
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
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "sendSegue") {
//
//            let destViewController = segue.destination as? ScannerVC
//            destViewController!.sendBarcodeDelegate = self
//            self.userID = destViewController?.stringValue ?? ""
//        }
//    }
    
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

extension TransferSeedVC: SendBarcodeDelegate {
    func sendBarcodeValue(userID: String) {
        
        self.scanTextField.text = userID
    }
}
