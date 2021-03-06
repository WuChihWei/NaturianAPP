//
//  PrivacyPolicyVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/8.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController, WKNavigationDelegate {
    
    let fullScreenSize = UIScreen.main.bounds.size
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")?
                .withTintColor(UIColor.darkGray)
                .withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
        
        // style
        view.backgroundColor = .white
        title = "隱私權政策"
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: fullScreenSize.height))
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        self.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func start() {
        self.view.endEditing(true)
        
        let url = URL(string: "https://www.privacypolicies.com/live/6a9d3d37-d0f0-4a6a-a17d-076c4afb7061")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
