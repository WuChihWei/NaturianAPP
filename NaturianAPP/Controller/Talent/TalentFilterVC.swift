//
//  TalentFilterVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/18.
//

import UIKit

class TalentFilterCell: UITableViewCell {
    
}

protocol TalentFilterDelegate: AnyObject {

    func sendFilterResult(filterResult: [TalentArticle])
}

class TalentFilterVC: UIViewController {
    
    weak var filterDelegate: TalentFilterDelegate?
    
    var telentManager = TalentManager()
    
    var filterResults: [TalentArticle] = []
    
    var addTransparentManager = AddDropDownField()
    
    var filterModel = TalentFilterModel(categories: [], seedValue: 0, genders: "", location: "") {
        didSet {
        if filterModel.categories != [] && filterModel.seedValue != 0 && filterModel.genders != "" && filterModel.location != "" {
            searchBtn.isEnabled = true
            searchBtn.backgroundColor = .clear
//            searchBtn.lkBorderWidth = 1
            searchBtn.backgroundColor = .NaturianColor.treatmentGreen
            searchBtn.setTitleColor(.white, for: .normal)
        } else {
            searchBtn.backgroundColor = .NaturianColor.darkGray
            searchBtn.isEnabled = false
        }
    }
}
    var filerResult = TalentFilterModel(categories: [], seedValue: 0, genders: "", location: "")
      
    let searchBtn = UIButton()
    let closeBtn = UIButton()
    
    let categoryLabel = UILabel()
    let foodButton = UIButton()
    let groceryButton = UIButton()
    let plantButton = UIButton()
    let adventureButton = UIButton()
    let exerciseButton = UIButton()
    let treatmentButton = UIButton()
    let categoryStackTop = UIStackView()
    let categoryStackBottom = UIStackView()

    let seedIcon = UIImageView()
    
    let seedMinLabel = UILabel()
    let seedMaxLabel = UILabel()
    let seedMidLabel = UILabel()

    let numberLabel = UILabel()
    
    let valueSlider = UISlider()

    let genderLabel = UILabel()
    let maleButton = UIButton()
    let femaleButton = UIButton()
    let undefinedButton = UIButton()
    var allGenderBtn = [UIButton]()
    let genderStack = UIStackView()
    
    let locationLabel = UILabel()
    let locationButton = UIButton()
    let tableView = UITableView()
    var dataSource = [String]()
    var didPickLocation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        view.lkCornerRadius = 30
        view.backgroundColor = .NaturianColor.lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TalentFilterCell.self, forCellReuseIdentifier: "Cell")
        tabBarController?.tabBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func filterSearch() {
      
        telentManager.fetchFilterTalent(category: filterModel.categories,
                                        seedValue: filterModel.seedValue,
                                        gender: filterModel.genders,
                                        location: filterModel.location) { [weak self] result in
            switch result {
                
            case .success(let filterArticles):
                
                self?.filterResults = filterArticles
                
                print(self?.filterResults as Any)
            
                self?.filterDelegate?.sendFilterResult(filterResult: self?.filterResults ?? [])
                
                self?.dismiss(animated: true)
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
    
    @objc func clickLocation(_ sender: Any) {
        
        dataSource = ["Taipei City", "Xinbei City",
                      "Taoyuan City", "Xinzhu City",
                      "Miaoli City", "Taizhong City",
                      "Zhanghua City", "Nantou City",
                      "Jiayi City", "Tainan City",
                      "Gaoxiong City", "Pingtung City",
                      "Yilan City", "HualianCity", "Taidong City"]
        
        addTransparentManager.addWithoutTransparent(radius: 15,
                                                    tableView: tableView,
                                                    view: self.view,
                                                    frames: locationButton.frame)
    }
    
    func setUp() {
        
        view.addSubview(categoryLabel)
        view.addSubview(seedIcon)
        view.addSubview(genderLabel)
        view.addSubview(searchBtn)
        view.addSubview(closeBtn)
        view.addSubview(categoryStackTop)
        view.addSubview(categoryStackBottom)
        
        view.addSubview(valueSlider)
        view.addSubview(seedMinLabel)
        view.addSubview(seedMidLabel)
        view.addSubview(seedMaxLabel)
        view.addSubview(numberLabel)
        
        view.addSubview(genderStack)
        view.addSubview(locationLabel)
        view.addSubview(locationButton)
        view.addSubview(searchBtn)
        
        categoryStackTop.addArrangedSubview(foodButton)
        categoryStackTop.addArrangedSubview(groceryButton)
        categoryStackTop.addArrangedSubview(plantButton)
        categoryStackBottom.addArrangedSubview(adventureButton)
        categoryStackBottom.addArrangedSubview(exerciseButton)
        categoryStackBottom.addArrangedSubview(treatmentButton)
        
        genderStack.addArrangedSubview(maleButton)
        genderStack.addArrangedSubview(femaleButton)
        genderStack.addArrangedSubview(undefinedButton)
        
        closeBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        allGenderBtn = [maleButton, foodButton, undefinedButton]
        searchBtn.addTarget(self, action: #selector(filterSearch), for: .touchUpInside)
        
        locationButton.addTarget(self, action: #selector(clickLocation(_:)), for: .touchUpInside)
        
        valueSlider.addTarget(self, action: #selector(sliderChange(_:)), for: .touchUpInside)
        
        maleButton.addTarget(self, action: #selector(didTapGenderBtn(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(didTapGenderBtn(_:)), for: .touchUpInside)
        undefinedButton.addTarget(self, action: #selector(didTapGenderBtn(_:)), for: .touchUpInside)
        
        foodButton.addTarget(self, action: #selector(didTapCategoryBtn(_:)), for: .touchUpInside)
        groceryButton.addTarget(self, action: #selector(didTapCategoryBtn(_:)), for: .touchUpInside)
        plantButton.addTarget(self, action: #selector(didTapCategoryBtn(_:)), for: .touchUpInside)
        adventureButton.addTarget(self, action: #selector(didTapCategoryBtn(_:)), for: .touchUpInside)
        treatmentButton.addTarget(self, action: #selector(didTapCategoryBtn(_:)), for: .touchUpInside)
        exerciseButton.addTarget(self, action: #selector(didTapCategoryBtn(_:)), for: .touchUpInside)
        
    }
    
    @objc func sliderChange(_ sender: UISlider) {
        
        sender.value.round()
        filterModel.seedValue = Int(sender.value)
        numberLabel.text = "< \(Int(sender.value).description)"
    }
    
    @objc func didTapGenderBtn(_ sender: UIButton) {

        switch sender {

        case maleButton:

            if sender.isSelected == false {
                filterModel.genders = "Male"
//                sender.isSelected = true
                undefinedButton.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
                femaleButton.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
                sender.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
            } else {
                sender.isSelected = false
                sender.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
            }

        case femaleButton:

            if sender.isSelected == false {
                filterModel.genders = "Female"
//                sender.isSelected = true
                sender.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
                maleButton.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
                undefinedButton.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
            } else {
                sender.isSelected = false
                sender.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
            }

        case undefinedButton:

            if sender.isSelected == false {
                filterModel.genders = "Undefined"
                maleButton.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
                femaleButton.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
                sender.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
            } else {
                sender.isSelected = false
                sender.setImage(#imageLiteral(resourceName: "unradio"), for: .normal)
            }
        default:
            break
        }
    }
    
    @objc func closeView(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func didTapCategoryBtn(_ sender: UIButton) {
        
        switch sender {
            
        case foodButton:
            
            if sender.isSelected == false {
                
                filterModel.categories.append("Food")
                sender.backgroundColor = .NaturianColor.treatmentGreen
                sender.setTitleColor(.white, for: .normal)
                sender.lkBorderWidth = 0
                sender.isSelected = true
                
            } else {

                filerResult.categories = filterModel.categories.filter { "\($0)" != "Food" }
                filterModel.categories = filerResult.categories
                sender.isSelected = false
                sender.backgroundColor = .clear
            }
            
        case groceryButton:
            
            if sender.isSelected == false {
                
                filterModel.categories.append("Grocery")
                sender.backgroundColor = .NaturianColor.treatmentGreen
                sender.setTitleColor(.white, for: .normal)
                sender.lkBorderWidth = 0
                sender.isSelected = true
                
            } else {
                
                filerResult.categories = filterModel.categories.filter { "\($0)" != "Grocery" }
                filterModel.categories = filerResult.categories
                sender.isSelected = false
                sender.backgroundColor = .clear
            }
            
        case plantButton:
            
            if sender.isSelected == false {
                
                filterModel.categories.append("Plant")
                sender.backgroundColor = .NaturianColor.treatmentGreen
                sender.setTitleColor(.white, for: .normal)
                sender.lkBorderWidth = 0
                sender.isSelected = true
                
            } else {
                
                filerResult.categories = filterModel.categories.filter { "\($0)" != "Plant" }
                filterModel.categories = filerResult.categories
                sender.isSelected = false
                sender.backgroundColor = .clear
            }
            
        case adventureButton:
            
            if sender.isSelected == false {
                
                filterModel.categories.append("Adventure")
                sender.backgroundColor = .NaturianColor.treatmentGreen
                sender.setTitleColor(.white, for: .normal)
                sender.lkBorderWidth = 0
                sender.isSelected = true
                
            } else {
                
                filerResult.categories = filterModel.categories.filter { "\($0)" != "Adventure" }
                filterModel.categories = filerResult.categories
                sender.isSelected = false
                sender.backgroundColor = .clear
            }
            
        case treatmentButton:
            
            if sender.isSelected == false {
                
                filterModel.categories.append("Treatment")
                sender.backgroundColor = .NaturianColor.treatmentGreen
                sender.setTitleColor(.white, for: .normal)
                sender.lkBorderWidth = 0
                sender.isSelected = true
                
            } else {
                
                filerResult.categories = filterModel.categories.filter { "\($0)" != "Treatment" }
                filterModel.categories = filerResult.categories
                sender.isSelected = false
                sender.backgroundColor = .clear
            }
            
        case exerciseButton:
            
            if sender.isSelected == false {
                
                filterModel.categories.append("Exercise")
                sender.backgroundColor = .NaturianColor.treatmentGreen
                sender.setTitleColor(.white, for: .normal)
                sender.lkBorderWidth = 0
                sender.isSelected = true
                
            } else {
                
                filerResult.categories = filterModel.categories.filter { "\($0)" != "Exercise" }
                filterModel.categories = filerResult.categories
                sender.isSelected = false
                sender.backgroundColor = .clear
            }
        default:
            break
        }
    }
    
    func layout() {
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        seedMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        seedMidLabel.translatesAutoresizingMaskIntoConstraints = false
        seedMinLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        seedIcon.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryStackTop.translatesAutoresizingMaskIntoConstraints = false
        categoryStackBottom.translatesAutoresizingMaskIntoConstraints = false
        valueSlider.translatesAutoresizingMaskIntoConstraints = false
        genderStack.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            closeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeBtn.heightAnchor.constraint(equalToConstant: 36),
            closeBtn.widthAnchor.constraint(equalToConstant: 36),

            categoryLabel.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 40),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            categoryLabel.heightAnchor.constraint(equalToConstant: 32),
            
            categoryStackTop.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            categoryStackTop.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            categoryStackTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            categoryStackTop.heightAnchor.constraint(equalToConstant: 36),

            categoryStackBottom.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            categoryStackBottom.topAnchor.constraint(equalTo: categoryStackTop.bottomAnchor, constant: 16),
            categoryStackBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            categoryStackBottom.heightAnchor.constraint(equalToConstant: 36),
            
            foodButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
            groceryButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
            plantButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
            adventureButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
            exerciseButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
            treatmentButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 80) / 3),
            
            foodButton.heightAnchor.constraint(equalToConstant: 36),
            groceryButton.heightAnchor.constraint(equalToConstant: 36),
            plantButton.heightAnchor.constraint(equalToConstant: 36),
            adventureButton.heightAnchor.constraint(equalToConstant: 36),
            exerciseButton.heightAnchor.constraint(equalToConstant: 36),
            treatmentButton.heightAnchor.constraint(equalToConstant: 36),
            
            seedIcon.topAnchor.constraint(equalTo: categoryStackBottom.bottomAnchor, constant: 24),
            seedIcon.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            seedIcon.heightAnchor.constraint(equalToConstant: 18),
            seedIcon.widthAnchor.constraint(equalToConstant: 18),
            
            numberLabel.centerYAnchor.constraint(equalTo: seedIcon.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: seedIcon.trailingAnchor, constant: 8),
            
            valueSlider.topAnchor.constraint(equalTo: seedIcon.bottomAnchor, constant: 18),
            valueSlider.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            valueSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            valueSlider.heightAnchor.constraint(equalToConstant: 8),
            
            seedMaxLabel.trailingAnchor.constraint(equalTo: valueSlider.trailingAnchor),
            seedMinLabel.leadingAnchor.constraint(equalTo: valueSlider.leadingAnchor),
            seedMidLabel.centerXAnchor.constraint(equalTo: valueSlider.centerXAnchor),

            seedMinLabel.topAnchor.constraint(equalTo: valueSlider.bottomAnchor, constant: 16),
            seedMaxLabel.topAnchor.constraint(equalTo: valueSlider.bottomAnchor, constant: 16),
            seedMidLabel.topAnchor.constraint(equalTo: valueSlider.bottomAnchor, constant: 16),

            genderLabel.topAnchor.constraint(equalTo: seedMaxLabel.bottomAnchor, constant: 24),
            genderLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            genderLabel.heightAnchor.constraint(equalToConstant: 32),
            
            genderStack.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 12),
            genderStack.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            genderStack.heightAnchor.constraint(equalToConstant: 20),
            genderStack.trailingAnchor.constraint(equalTo: valueSlider.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: genderStack.bottomAnchor, constant: 24),
            locationLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 32),
            
            locationButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            locationButton.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            locationButton.trailingAnchor.constraint(equalTo: valueSlider.trailingAnchor),
            locationButton.heightAnchor.constraint(equalToConstant: 36),
            
            searchBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            searchBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBtn.widthAnchor.constraint(equalTo: locationButton.widthAnchor),
            searchBtn.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: Drop down selection
    // show drop down selection button
    // remove drop down selection button
    @objc func removeTransparentView() {
        let frames = locationButton.frame
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            //            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x,
                                          y: frames.origin.y + frames.height,
                                          width: frames.width,
                                          height: 0)
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        locationButton.setTitle(dataSource[indexPath.row], for: .normal)
        filterModel.location = dataSource[indexPath.row]
        removeTransparentView()
        print(filterModel)
    }
}

// MARK: UI

extension TalentFilterVC {
    
    func style() {
        
        searchBtn.isEnabled = false
        searchBtn.backgroundColor = .green
        
        closeBtn.setImage(UIImage(named: "dismiss"), for: .normal)
        
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont(name: Roboto.bold.rawValue, size: 20)
        
        foodButton.setTitle("Food", for: .normal)
        foodButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        foodButton.lkBorderWidth = 1
        foodButton.lkCornerRadius = 18
        foodButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        
        groceryButton.setTitle("Grocery", for: .normal)
        groceryButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        groceryButton.lkBorderWidth = 1
        groceryButton.lkCornerRadius = 18
        groceryButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        
        plantButton.setTitle("Plant", for: .normal)
        plantButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        plantButton.lkBorderWidth = 1
        plantButton.lkCornerRadius = 18
        plantButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        
        adventureButton.setTitle("Adventure", for: .normal)
        adventureButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        adventureButton.lkBorderWidth = 1
        adventureButton.lkCornerRadius = 18
        adventureButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        
        exerciseButton.setTitle("Exercise", for: .normal)
        exerciseButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        exerciseButton.lkBorderWidth = 1
        exerciseButton.lkCornerRadius = 18
        exerciseButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        
        treatmentButton.setTitle("Treatment", for: .normal)
        treatmentButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        treatmentButton.lkBorderWidth = 1
        treatmentButton.lkCornerRadius = 18
        treatmentButton.setTitleColor(.NaturianColor.darkGray, for: .normal)

        seedIcon.image = UIImage(named: "seedgray")
        
        numberLabel.font = UIFont(name: Roboto.bold.rawValue, size: 20)
        numberLabel.textColor = .gray
        numberLabel.text = "<"
        
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 1000
        valueSlider.isContinuous = true
        valueSlider.tintColor = .NaturianColor.treatmentGreen
        
        seedMinLabel.text = "0"
        seedMinLabel.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        seedMinLabel.textAlignment = .left
        
        seedMidLabel.text = "500"
        seedMidLabel.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        seedMidLabel.textAlignment = .center
        
        seedMaxLabel.text = "1000"
        seedMaxLabel.textAlignment = .right
        seedMaxLabel.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        
        genderLabel.text = "Gender"
        genderLabel.font = UIFont(name: Roboto.bold.rawValue, size: 20)

        locationLabel.text = "Location"
        locationLabel.font = UIFont(name: Roboto.bold.rawValue, size: 20)
        
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.setTitle("Choose Your Location", for: .normal)
        locationButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 18)
        locationButton.contentEdgeInsets.left = 10
        locationButton.lkBorderColor = .gray
        locationButton.lkBorderWidth = 1
        locationButton.lkCornerRadius = 4
        locationButton.contentHorizontalAlignment = .left
        
        tableView.lkBorderWidth = 1
        tableView.lkBorderColor = .gray
        
        maleButton.setTitle("  Male", for: .normal)
        maleButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 16)
        maleButton.setImage(UIImage(named: "unradio"), for: .normal)
        maleButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        maleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        maleButton.contentHorizontalAlignment = .leading
        
        femaleButton.setTitle("  Female", for: .normal)
        femaleButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 16)
        femaleButton.setImage(UIImage(named: "unradio"), for: .normal)
        femaleButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        femaleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        femaleButton.contentHorizontalAlignment = .center

        undefinedButton.setTitle("  Undefined", for: .normal)
        undefinedButton.titleLabel?.font = UIFont(name: Roboto.regular.rawValue, size: 16)
        undefinedButton.setImage(UIImage(named: "unradio"), for: .normal)
        undefinedButton.setTitleColor(.NaturianColor.darkGray, for: .normal)
        undefinedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        undefinedButton.contentHorizontalAlignment = .trailing
        
        categoryStackTop.axis = .horizontal
        categoryStackTop.alignment = .leading
        categoryStackTop.distribution = .equalSpacing
        
        categoryStackBottom.axis = .horizontal
        categoryStackBottom.alignment = .leading
        categoryStackBottom.distribution = .equalSpacing
        
        genderStack.axis = .horizontal
        genderStack.alignment = .leading
        genderStack.distribution = .equalSpacing
        genderStack.spacing = 8
        
        searchBtn.setTitle("Search", for: .normal)
        searchBtn.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        searchBtn.backgroundColor = .NaturianColor.darkGray
        searchBtn.lkCornerRadius = 24
        searchBtn.setTitleColor(.white, for: .normal)
    }
}
