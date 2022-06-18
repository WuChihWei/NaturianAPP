//
//  ForumViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ForumViewController: UIViewController {
    
    var fullScreenSize: CGSize!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    private var titles = ["Food",
                          "Grocery",
                          "Plant",
                          "Adventure",
                          "Exercise",
                          "Treatment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup BackgroundColor
        self.view.backgroundColor = UIColor.white
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: setup Layout
    func setup() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 10
        
        layout.itemSize = CGSize(
            width: UIScreen.width / 2 - 10,
            height: UIScreen.width / 2 - 10)
        
        // header & footer
        layout.headerReferenceSize = CGSize(width: UIScreen.width, height: 40)
        layout.footerReferenceSize = CGSize(width: UIScreen.width, height: 40)
        
        let myCollectionView = UICollectionView(frame: CGRect(
            x: 0, y: 20,
            width: UIScreen.width,
            height: UIScreen.height
        ), collectionViewLayout: layout)
        
        myCollectionView.register(
            ForumCollectionViewCell.self,
            forCellWithReuseIdentifier: "Cell")
        
        myCollectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header")
        
        myCollectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Footer")
        
        // 設置委任對象
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        self.view.addSubview(myCollectionView)
    }
    
}

extension ForumViewController: UICollectionViewDelegate {
    
}

extension ForumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? ForumCollectionViewCell else {
            
            fatalError("can't find ForumCollectionViewCell")
        }
        cell.titleLabel.text = titles[indexPath.item]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you chose \(indexPath.item + 1) category")
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ForumLobbyViewController") as? ForumLobbyViewController else {
            
            fatalError("can't find ForumLobbyViewController")
        }
        self.navigationController?.pushViewController(vc, animated: true)
        vc.seletectedTitle = titles[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.width,
            height: 40))
        label.textAlignment = .center
        
        // header
        if kind == UICollectionView.elementKindSectionHeader {
            
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: "Header",
                                                                           for: indexPath)
            
            reusableView.backgroundColor = UIColor.gray
            label.text = "Header"
            label.textColor = UIColor.white
        } else if kind == UICollectionView.elementKindSectionFooter {
            
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                           withReuseIdentifier: "Footer",
                                                                           for: indexPath)
            
            reusableView.backgroundColor = UIColor.gray
            label.text = "Footer"
            label.textColor = UIColor.white
        }
        
        reusableView.addSubview(label)
        return reusableView
    }
}
