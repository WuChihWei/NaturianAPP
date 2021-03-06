//
//  HomeTopTVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/7.
//

import UIKit
import MessageKit

protocol SelectedCollectionItemDelegate: AnyObject {
    func selectedCollectionItem(index: Int)
}

protocol SelectedBtnDelegate: AnyObject {
    func selectedBtn(sender: Sender)
}

class HomeTopTVCell: UITableViewCell {
    
    weak var delegate: SelectedCollectionItemDelegate?
    
    static let identifer = "\(HomeTopTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categories = [ (name: "Food", imageName: "home_food"),
                       (name: "Grocery", imageName: "home_grocery"),
                       (name: "Plant", imageName:"home_plant"),
                       (name: "Adventure", imageName: "home_adventure"),
                       (name: "Exercise", imageName: "home_exercise"),
                       (name: "Treatment", imageName: "home_treatment") ]
    
    
//    var images = [  "food_icon","grocery_icon"),
//                       (name: "Plant", imageName:"plant_icon"),
//                       (name: "Adventure", imageName: "adventure_icon"),
//                       (name: "Exercise", imageName: "exercise_icon"),
//                       (name: "Treatment", imageName: "treatment_icon") ]
    
    let firstLB = UILabel()
    let secondLB = UILabel()
    let thirdtLB = UILabel()
    let bottomTitleView = UIView()
    let titleLB = UILabel()
    
    let seedButton = UIButton()
    let myTalentButton = UIButton()
    let collectionButton = UIButton()
    let massageButton = UIButton()
    
    let seedLB = UILabel()
    let myTalentLB = UILabel()
    let collectionLB = UILabel()
    let massageLB = UILabel()
    let buttonLB = UIStackView()
    
    let seedStack = UIStackView()
    let myTalentStack = UIStackView()
    let collectionStack = UIStackView()
    let massageStack = UIStackView()

    let buttonStack = UIStackView()
    
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
        
        collectionView.layoutIfNeeded()
    }
    
    func styleObject() {
        
        contentView.backgroundColor = .NaturianColor.lightGray
        bottomTitleView.backgroundColor = .white
        
        firstLB.text = "Hi, Naturian"
        firstLB.textColor = .NaturianColor.navigationGray
        firstLB.font = UIFont(name: Roboto.black.rawValue, size: 32)
        firstLB.numberOfLines = 0
        
        secondLB.text = "Stop Your Default Life"
        secondLB.textColor = .NaturianColor.navigationGray
        secondLB.font = UIFont(name: Roboto.black.rawValue, size: 32)
        secondLB.numberOfLines = 0
        
        seedLB.text = "Seed"
        seedLB.textColor = .NaturianColor.darkGray
        seedLB.font = UIFont(name: Roboto.black.rawValue, size: 12)
        
        myTalentLB.text = "My Talent"
        myTalentLB.textColor = .NaturianColor.darkGray
        myTalentLB.font = UIFont(name: Roboto.black.rawValue, size: 12)
        
        collectionLB.text = "Collection"
        collectionLB.textColor = .NaturianColor.darkGray
        collectionLB.font = UIFont(name: Roboto.black.rawValue, size: 12)
        
        massageLB.text = "Massage"
        massageLB.textColor = .NaturianColor.darkGray
        massageLB.font = UIFont(name: Roboto.black.rawValue, size: 12)
        
        titleLB.text = "Hot Articles"
        titleLB.textColor = .NaturianColor.darkGray
        titleLB.font = UIFont(name: Roboto.bold.rawValue, size: 20)
        
        seedButton.setImage(UIImage(named: "whitetransfer"), for: .normal)
        seedButton.backgroundColor = .NaturianColor.navigationGray
        seedButton.lkCornerRadius = 32
        seedButton.lkBorderColor = .white
        seedButton.lkBorderWidth = 2
        
        myTalentButton.setImage(UIImage(named: "whitetalent"), for: .normal)
        myTalentButton.backgroundColor = .NaturianColor.navigationGray
        myTalentButton.lkCornerRadius = 32
        myTalentButton.lkBorderColor = .white
        myTalentButton.lkBorderWidth = 2
        
        collectionButton.setImage(UIImage(named: "whitecollection"), for: .normal)
        collectionButton.backgroundColor = .NaturianColor.navigationGray
        collectionButton.lkCornerRadius = 32
        collectionButton.lkBorderColor = .white
        collectionButton.lkBorderWidth = 2
        
        massageButton.setImage(UIImage(named: "whitemanager"), for: .normal)
        massageButton.backgroundColor = .NaturianColor.navigationGray
        massageButton.lkCornerRadius = 32
        massageButton.lkBorderColor = .white
        massageButton.lkBorderWidth = 2
        
        titleStack.axis = .vertical
        titleStack.alignment = .leading
        titleStack.spacing = 0.8
        
        seedStack.axis = .vertical
        seedStack.alignment = .center
        seedStack.spacing = 6
        
        myTalentStack.axis = .vertical
        myTalentStack.alignment = .center
        myTalentStack.spacing = 6
        
        collectionStack.axis = .vertical
        collectionStack.alignment = .center
        collectionStack.spacing = 6
        
        massageStack.axis = .vertical
        massageStack.alignment = .center
        massageStack.spacing = 6
        
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.distribution = .equalSpacing
       
        bottomTitleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomTitleView.lkCornerRadius = 30
    }
    
    func layout() {
        
        contentView.addSubview(titleStack)
        contentView.addSubview(collectionView)
        contentView.addSubview(buttonStack)
        contentView.addSubview(bottomTitleView)
        bottomTitleView.addSubview(titleLB)
        
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        bottomTitleView.translatesAutoresizingMaskIntoConstraints = false

        seedStack.addArrangedSubview(seedButton)
        seedStack.addArrangedSubview(seedLB)
        
        myTalentStack.addArrangedSubview(myTalentButton)
        myTalentStack.addArrangedSubview(myTalentLB)
        
        collectionStack.addArrangedSubview(collectionButton)
        collectionStack.addArrangedSubview(collectionLB)
        
        massageStack.addArrangedSubview(massageButton)
        massageStack.addArrangedSubview(massageLB)

        buttonStack.addArrangedSubview(seedStack)
        buttonStack.addArrangedSubview(myTalentStack)
        buttonStack.addArrangedSubview(collectionStack)
        buttonStack.addArrangedSubview(massageStack)

        titleStack.addArrangedSubview(firstLB)
        titleStack.addArrangedSubview(secondLB)
        
        NSLayoutConstraint.activate([
            
            titleStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleStack.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 24),
            titleStack.heightAnchor.constraint(equalToConstant: 80),
            titleStack.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -24),
            
            firstLB.heightAnchor.constraint(equalToConstant: 37),
            secondLB.heightAnchor.constraint(equalToConstant: 37),
            thirdtLB.heightAnchor.constraint(equalToConstant: 37),
            
            collectionView.topAnchor.constraint(equalTo: titleStack.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            seedButton.widthAnchor.constraint(equalToConstant: 64),
            seedButton.heightAnchor.constraint(equalToConstant: 64),
            seedLB.centerXAnchor.constraint(equalTo: seedButton.centerXAnchor),
            seedStack.widthAnchor.constraint(equalToConstant: 64),
            
            myTalentButton.widthAnchor.constraint(equalToConstant: 64),
            myTalentButton.heightAnchor.constraint(equalToConstant: 64),
            myTalentLB.centerXAnchor.constraint(equalTo: myTalentButton.centerXAnchor),
            myTalentStack.widthAnchor.constraint(equalToConstant: 64),
            collectionButton.widthAnchor.constraint(equalToConstant: 64),
            collectionButton.heightAnchor.constraint(equalToConstant: 64),
            collectionLB.centerXAnchor.constraint(equalTo: collectionButton.centerXAnchor),
            collectionStack.widthAnchor.constraint(equalToConstant: 64),
            
            massageButton.widthAnchor.constraint(equalToConstant: 64),
            massageButton.heightAnchor.constraint(equalToConstant: 64),
            massageLB.centerXAnchor.constraint(equalTo: massageButton.centerXAnchor),
            massageStack.widthAnchor.constraint(equalToConstant: 64),
            
            buttonStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            bottomTitleView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 15),
            bottomTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomTitleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomTitleView.heightAnchor.constraint(equalToConstant: 48),
            
            titleLB.bottomAnchor.constraint(equalTo: bottomTitleView.bottomAnchor),
            titleLB.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor)
            
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
        
        cell.lkCornerRadius = 35
        cell.backgroundColor = .clear
        //        cell.tilteLB.text = categories[indexPath.row].name
        cell.cardview.image = UIImage(named: "\(categories[indexPath.row].imageName)")
        cell.layoutIfNeeded()
        cell.cardview.layoutIfNeeded()
        cell.cardview.clipsToBounds = true
        cell.cardview.backgroundColor = .clear
        cell.cardview.contentMode = .scaleAspectFill
        
        cell.backgroundColor = .white
        return cell
    }
    
}

extension HomeTopTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        let itemNum = indexPath.row
        self.delegate?.selectedCollectionItem(index: itemNum)
    }
}

extension HomeTopTVCell: UIScrollViewDelegate {
    
}
