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
 
    private var categories = [ (name: "Food", imageName: ""),
                               (name: "Grocery", imageName: ""),
                               (name: "Plant", imageName:""),
                               (name: "Adventure", imageName: ""),
                               (name: "Exercise", imageName: ""),
                               (name: "Treatment", imageName: "") ]
    
    //    private enum LayoutConstant {
    //        static let spacing: CGFloat = 16.0
    //        static let itemHeight: CGFloat = 200.0
    //    }
        
    let firstLB = UILabel()
    let secondLB = UILabel()
    let thirdtLB = UILabel()
    let titleStack = UIStackView()
    
    let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        setupViews()
        setupLayouts()
        style()
    }
    
    private func setupViews() {
        
        view.addSubview(titleStack)
        view.addSubview(collectionView)
        collectionView.register(ForumLobbyCVCell.self, forCellWithReuseIdentifier: ForumLobbyCVCell.identifer)
    }
    
    private func style() {
        
        collectionView.backgroundColor = .clear
        view.backgroundColor = .NaturianColor.navigationGray

        firstLB.text = "Discover"
        firstLB.textColor = .white
        firstLB.font = UIFont(name: Roboto.black.rawValue, size: 37)
        firstLB.numberOfLines = 0
        
        secondLB.text = "Your Own"
        secondLB.textColor = .white
        secondLB.font = UIFont(name: Roboto.black.rawValue, size: 37)
        secondLB.numberOfLines = 0
        
        thirdtLB.text = "Universe"
        thirdtLB.textColor = .white
        thirdtLB.font = UIFont(name: Roboto.black.rawValue, size: 37)
        thirdtLB.numberOfLines = 0

        titleStack.axis = .vertical
        titleStack.alignment = .leading
        titleStack.spacing = 0.8
    }
    
    private func setupLayouts() {
        
        titleStack.addArrangedSubview(firstLB)
        titleStack.addArrangedSubview(secondLB)
        titleStack.addArrangedSubview(thirdtLB)

        titleStack.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for `collectionView`
        NSLayoutConstraint.activate([
            
            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleStack.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 24),
            titleStack.heightAnchor.constraint(equalToConstant: 120),
            firstLB.heightAnchor.constraint(equalToConstant: 37),
            secondLB.heightAnchor.constraint(equalToConstant: 37),
            thirdtLB.heightAnchor.constraint(equalToConstant: 37),

            collectionView.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

extension ForumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForumLobbyCVCell.identifer, for: indexPath) as?
                ForumLobbyCVCell else { fatalError("can't find Cell") }
        
        cell.lkCornerRadius = 10
        cell.tilteLB.text = categories[indexPath.row].name
        cell.backgroundColor = .gray
        return cell
    }
}

extension ForumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.bounds.width - 48 - 15) / 2
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ForumLobbyViewController") as? ForumLobbyViewController else {
            
            fatalError("can't find ForumLobbyViewController")
        }
        vc.forumTitle = categories[indexPath.row].name
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ForumViewController: UICollectionViewDelegate {
    
}
