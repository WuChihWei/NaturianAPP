//
//  HomeTopTVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/7.
//

import UIKit

class HomeTopTVCell: UITableViewCell {
    
    static let identifer = "\(HomeTopTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categories = [ (name: "Food", imageName: "food_icon"),
                       (name: "Grocery", imageName: "grocery_icon"),
                       (name: "Plant", imageName:"plant_icon"),
                       (name: "Adventure", imageName: "adventure_icon"),
                       (name: "Exercise", imageName: "exercise_icon"),
                       (name: "Treatment", imageName: "treatment_icon") ]
    
    let firstLB = UILabel()
    let secondLB = UILabel()
    let thirdtLB = UILabel()
    
    let seedButton = UIButton()
    let myTalentButton = UIButton()
    let collectionButton = UIButton()
    let massageButton = UIButton()
    
    let titleStack = UIStackView()
    let subview = UIView()
    
    let collectionView: UICollectionView = {
        let viewLayout = HomeCVFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCVCell.self, forCellWithReuseIdentifier: HomeCVCell.identifer)
        collectionView.showsHorizontalScrollIndicator = false
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        collectionView.backgroundColor = .clear
        contentView.backgroundColor = .NaturianColor.navigationGray
        
        firstLB.text = "Hi, Naturian"
        firstLB.textColor = .white
        firstLB.font = UIFont(name: Roboto.black.rawValue, size: 32)
        firstLB.numberOfLines = 0
        
        secondLB.text = "Stop Your Default Life"
        secondLB.textColor = .white
        secondLB.font = UIFont(name: Roboto.black.rawValue, size: 32)
        secondLB.numberOfLines = 0
        
        titleStack.axis = .vertical
        titleStack.alignment = .leading
        titleStack.spacing = 0.8
    }
    
    func layout() {
        
        titleStack.addArrangedSubview(firstLB)
        titleStack.addArrangedSubview(secondLB)
        titleStack.addArrangedSubview(thirdtLB)
        
        contentView.addSubview(titleStack)
        contentView.addSubview(collectionView)
        
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleStack.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 24),
            titleStack.heightAnchor.constraint(equalToConstant: 70),
            
            firstLB.heightAnchor.constraint(equalToConstant: 37),
            secondLB.heightAnchor.constraint(equalToConstant: 37),
            thirdtLB.heightAnchor.constraint(equalToConstant: 37),
            
            collectionView.topAnchor.constraint(equalTo: titleStack.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension HomeTopTVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVCell.identifer, for: indexPath) as?
                HomeCVCell else { fatalError("can't find Cell") }
        
        cell.lkCornerRadius = 15
        //        cell.tilteLB.text = categories[indexPath.row].name
        cell.cardview.image = UIImage(named: "\(categories[indexPath.row].imageName)")
        cell.backgroundColor = .white
        return cell
    }
    
}

extension HomeTopTVCell: UICollectionViewDelegate {
    
}
