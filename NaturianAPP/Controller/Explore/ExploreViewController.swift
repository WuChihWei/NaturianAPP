//
//  ExploreViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit

class ExploreViewController: UIViewController {
    
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
        
        let exploreCollectionView = UICollectionView(frame: CGRect(
            x: 0, y: 20,
            width: UIScreen.width,
            height: UIScreen.height
        ), collectionViewLayout: layout)
        
        exploreCollectionView.register(
            ExploreCollectionViewCell.self,
            forCellWithReuseIdentifier: "Cell")
        
        exploreCollectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header")
        
        exploreCollectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Footer")
        
        // 設置委任對象
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        
        self.view.addSubview(exploreCollectionView)
    }
    
}

extension ExploreViewController: UICollectionViewDelegate {
    
}

extension ExploreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? ExploreCollectionViewCell else {
            
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
            
            reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "Header",
                for: indexPath)
            
            reusableView.backgroundColor = UIColor.gray
            label.text = "Header"
            label.textColor = UIColor.white
        } else if kind == UICollectionView.elementKindSectionFooter {
            
            reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
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
