//
//  PopViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/24.
//

import UIKit

class PopViewController: UIViewController {
    
    var userID: String = ""
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backbutton(_ sender: Any) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let scannerVC = storyboard?.instantiateViewController(withIdentifier: "ScannerVC") as? ScannerVC else {
            return
        }
        scannerVC.sendBarcodeDelegate = self
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendSegue" {
            
            let destViewController = segue.destination as? ScannerVC
            destViewController!.sendBarcodeDelegate = self
            userID = destViewController?.stringValue ?? ""
        }
    }
}

extension PopViewController: SendBarcodeDelegate {
    func sendBarcodeValue(userID: String) {
        
        self.userID = userID
    }
}
