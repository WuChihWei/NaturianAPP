//
//  TalentFilterVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/18.
//

import UIKit

class TalentFilterCell: UITableViewCell {
    
}

class TalentFilterVC: UIViewController {
    
    let categoryLabel = UILabel()
    let foodButton = UIButton()
    let groceryButton = UIButton()
    let plantButton = UIButton()
    let adventureButton = UIButton()
    let exerciseButton = UIButton()
    let treatmentButton = UIButton()
    let categoryStackTop = UIStackView()
    let categoryStackBottom = UIStackView()
    var allCategoryBtn = [UIButton]()
    
    var btnALLGender = [UIButton]()
    let seedsLabel = UILabel()
    let valueSlider = UISlider()
    
    let genderLabel = UILabel()
    let maleButton = UIButton()
    let feMaleButton = UIButton()
    let undefinedButton = UIButton()
    let genderStack = UIStackView()
    
    let locationLabel = UILabel()
    let locationButton = UIButton()
    let tableView = UITableView()
    //    let transparentView = UIView()
    var dataSource = [String]()
    var didPickLocation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        btnALLGender = [maleButton, feMaleButton, undefinedButton]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TalentFilterCell.self, forCellReuseIdentifier: "Cell")
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @objc func clickLocation(_ sender: Any) {
        dataSource = ["Taipei City", "Xinbei City",
                      "Taoyuan City", "Xinzhu City",
                      "Miaoli City", "Taizhong City",
                      "Zhanghua City", "Nantou City",
                      "Jiayi City", "Tainan City",
                      "Gaoxiong City", "Pingtung City",
                      "Yilan City", "HualianCity", "Taidong City"]
        
        addTransparentView(frames: locationButton.frame)
    }
    
    func setUp() {
        
        locationButton.addTarget(self, action: #selector(clickLocation(_:)), for: .touchUpInside)
        
        view.addSubview(categoryLabel)
        view.addSubview(seedsLabel)
        view.addSubview(genderLabel)
        
        view.addSubview(categoryStackTop)
        view.addSubview(categoryStackBottom)
        
        view.addSubview(valueSlider)
        view.addSubview(genderStack)
        view.addSubview(locationLabel)
        view.addSubview(locationButton)
        
        categoryStackTop.addArrangedSubview(foodButton)
        categoryStackTop.addArrangedSubview(groceryButton)
        categoryStackTop.addArrangedSubview(plantButton)
        categoryStackBottom.addArrangedSubview(adventureButton)
        categoryStackBottom.addArrangedSubview(exerciseButton)
        categoryStackBottom.addArrangedSubview(treatmentButton)
        
        genderStack.addArrangedSubview(maleButton)
        genderStack.addArrangedSubview(feMaleButton)
        genderStack.addArrangedSubview(undefinedButton)
        
        //        maleButton.addTarget(self, action: #selector(btnRadioCategoryClicked(_:)), for: .touchUpInside)
        //        feMaleButton.addTarget(self, action: #selector(btnRadioCategoryClicked(_:)), for: .touchUpInside)
        //        undefinedButton.addTarget(self, action: #selector(btnRadioCategoryClicked(_:)), for: .touchUpInside)
    }
    
    @objc func btnRadioCategoryClicked(_ sender: UIButton) {
        
        for button in btnALLGender {
            
            button.addTarget(self, action: #selector(btnRadioCategoryClicked(_:)), for: .touchUpInside)
            
            if sender.tag == button.tag {
                button.isSelected = true
                button.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
                print(sender)
            } else {
                button.isSelected = false
                button.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
            }
        }
    }
    
    @objc func didTapCategoryBtn(_ sender: UIButton) {
        
        for categoryBtn in allCategoryBtn {
            
            categoryBtn.backgroundColor = .green
            
            if categoryBtn.backgroundColor == .green {
                categoryBtn.backgroundColor = .brown
            }
            else if categoryBtn.backgroundColor == .brown {
                categoryBtn.backgroundColor = .green
            }
        }
    }
        
        let buttonA = CustomButton()
        
        func style() {
            
            categoryLabel.text = "Category"
            categoryLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            
            foodButton.setTitle("Food", for: .normal)
            foodButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            foodButton.lkBorderWidth = 1
            foodButton.lkCornerRadius = 14
            foodButton.setTitleColor(.gray, for: .normal)
            foodButton
            
            groceryButton.setTitle("Food", for: .normal)
            groceryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            groceryButton.lkBorderWidth = 1
            groceryButton.lkCornerRadius = 14
            groceryButton.setTitleColor(.gray, for: .normal)
            
            plantButton.setTitle("Plant", for: .normal)
            plantButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            plantButton.lkBorderWidth = 1
            plantButton.lkCornerRadius = 14
            plantButton.setTitleColor(.gray, for: .normal)
            
            adventureButton.setTitle("Adventure", for: .normal)
            adventureButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            adventureButton.lkBorderWidth = 1
            adventureButton.lkCornerRadius = 14
            adventureButton.setTitleColor(.gray, for: .normal)
            
            exerciseButton.setTitle("Exercise", for: .normal)
            exerciseButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            exerciseButton.lkBorderWidth = 1
            exerciseButton.lkCornerRadius = 14
            exerciseButton.setTitleColor(.gray, for: .normal)
            
            treatmentButton.setTitle("Treatment", for: .normal)
            treatmentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            treatmentButton.lkBorderWidth = 1
            treatmentButton.lkCornerRadius = 14
            treatmentButton.setTitleColor(.gray, for: .normal)
            
            seedsLabel.text = "Seeds"
            seedsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            valueSlider.minimumValue = 0
            valueSlider.maximumValue = 200
            valueSlider.isContinuous = true
            valueSlider.tintColor = .green
            
            genderLabel.text = "Gender"
            genderLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            
            locationLabel.text = "Location"
            locationLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            
            locationButton.setTitleColor(.black, for: .normal)
            locationButton.setTitle("Location", for: .normal)
            locationButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            locationButton.lkBorderColor = .gray
            locationButton.lkBorderWidth = 1
            locationButton.contentHorizontalAlignment = .left
            
            tableView.lkBorderWidth = 1
            tableView.lkBorderColor = .gray
            
            maleButton.setTitle("Male", for: .normal)
            maleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            maleButton.setImage(UIImage(named: "unradio"), for: .normal)
            //        maleButton.setImage(UIImage(named: "radio"), for: .selected)
            maleButton.setTitleColor(.gray, for: .normal)
            maleButton.tag = 0
            
            feMaleButton.setTitle("Female", for: .normal)
            feMaleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            feMaleButton.setImage(UIImage(named: "unradio"), for: .normal)
            feMaleButton.setTitleColor(.gray, for: .normal)
            feMaleButton.tag = 1
            //        feMaleButton.setImage(UIImage(named: "radio"), for: .selected)
            
            undefinedButton.setTitle("Undefined", for: .normal)
            undefinedButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            undefinedButton.setImage(UIImage(named: "unradio"), for: .normal)
            //        undefinedButton.setImage(UIImage(named: "radio"), for: .selected)
            undefinedButton.setTitleColor(.gray, for: .normal)
            undefinedButton.tag = 2
            
            categoryStackTop.axis = .horizontal
            categoryStackTop.alignment = .leading
            categoryStackTop.distribution = .equalSpacing
            categoryStackBottom.axis = .horizontal
            categoryStackBottom.alignment = .leading
            categoryStackBottom.distribution = .equalSpacing
            //        categoryStack.distribution = .green
            
            genderStack.axis = .horizontal
            genderStack.alignment = .leading
            genderStack.spacing = 8
        }
        
        func layout() {
            
            categoryLabel.translatesAutoresizingMaskIntoConstraints = false
            seedsLabel.translatesAutoresizingMaskIntoConstraints = false
            genderLabel.translatesAutoresizingMaskIntoConstraints = false
            categoryStackTop.translatesAutoresizingMaskIntoConstraints = false
            categoryStackBottom.translatesAutoresizingMaskIntoConstraints = false
            valueSlider.translatesAutoresizingMaskIntoConstraints = false
            genderStack.translatesAutoresizingMaskIntoConstraints = false
            locationLabel.translatesAutoresizingMaskIntoConstraints = false
            locationButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                
                categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                categoryLabel.heightAnchor.constraint(equalToConstant: 32),
                
                categoryStackTop.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
                categoryStackTop.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
                categoryStackTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                
                categoryStackBottom.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
                categoryStackBottom.topAnchor.constraint(equalTo: categoryStackTop.bottomAnchor, constant: 16),
                categoryStackBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                
                foodButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
                groceryButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
                plantButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
                adventureButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
                exerciseButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
                treatmentButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
                
                seedsLabel.topAnchor.constraint(equalTo: categoryStackBottom.bottomAnchor, constant: 16),
                seedsLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
                seedsLabel.heightAnchor.constraint(equalToConstant: 32),
                
                valueSlider.topAnchor.constraint(equalTo: seedsLabel.bottomAnchor, constant: 16),
                valueSlider.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
                valueSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                valueSlider.heightAnchor.constraint(equalToConstant: 8),
                
                genderLabel.topAnchor.constraint(equalTo: valueSlider.bottomAnchor, constant: 16),
                genderLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
                genderLabel.heightAnchor.constraint(equalToConstant: 32),
                
                genderStack.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 16),
                genderStack.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
                genderStack.heightAnchor.constraint(equalToConstant: 20),
                
                locationLabel.topAnchor.constraint(equalTo: genderStack.bottomAnchor, constant: 16),
                locationLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
                locationLabel.heightAnchor.constraint(equalToConstant: 32),
                
                locationButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
                locationButton.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
                locationButton.trailingAnchor.constraint(equalTo: valueSlider.trailingAnchor)
            ])
        }
        
        // MARK: Drop down selection
        // show drop down selection button
        func addTransparentView(frames: CGRect) {
            //        let window = UIApplication.shared.keyWindow
            //        transparentView.frame = window?.frame ?? self.view.frame
            //        self.view.addSubview(transparentView)
            
            tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            self.view.addSubview(tableView)
            tableView.layer.cornerRadius = 5
            
            //        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            tableView.reloadData()
            //        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
            //        transparentView.addGestureRecognizer(tapgesture)
            //        transparentView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                //            self.transparentView.alpha = 0.5
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
            }, completion: nil)
        }
        
        // remove drop down selection button
        @objc func removeTransparentView() {
            let frames = locationButton.frame
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                //            self.transparentView.alpha = 0
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            }, completion: nil)
        }
    }

// MARK: Drop down tableView
extension TalentFilterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.textLabel?.textAlignment = .left
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        locationButton.setTitle(dataSource[indexPath.row], for: .normal)
        didPickLocation = dataSource[indexPath.row]
        removeTransparentView()
        print(didPickLocation)
    }
}
