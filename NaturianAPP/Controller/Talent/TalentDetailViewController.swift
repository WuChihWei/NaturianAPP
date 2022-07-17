//
//  TalentDetailViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/18.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import FirebaseAuth
import Lottie
import CoreMedia

class TalentDetailViewController: UIViewController {
    
    var db: Firestore?
    var talentManager = TalentManager()
    var userManager = UserManager()
    let userID = Auth.auth().currentUser?.uid
//        let userID = "2"
    //    let userID = "1"
    let closeButton = UIButton()
    var appliedState: Int = 0
    private let tableView = UITableView()
    
    var selectedArticle: TalentArticle!
    var userModels: UserModel!
    let applyButton = UIButton()
    var isLiked = true
    
    let seedValue = UILabel()
    let seedIcon = UIImageView()
    private let seedStack = UIStackView()
    let bottomView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for camera
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        setUp()
        style()
        layout()
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        //        view.layoutIfNeeded()
        //        tableView.layoutIfNeeded()
        //        fetchUserData()
    }
    
    override func viewDidLayoutSubviews() {
        
        view.layoutIfNeeded()
        bottomView.layoutIfNeeded()
        bottomView.clipsToBounds = true
        tableView.layoutIfNeeded()
    }
    
    func setupLottie() {
        let animationView = AnimationView(name: "lf20_k3ant2j6")
        //           animationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //           animationView.center = self.view.center
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -14).isActive = true
        animationView.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 380).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        animationView.contentMode = .scaleAspectFill
  
        animationView.play(completion: { (finished) in
            animationView.isHidden = true
        })
    }
    
    @objc func didApply(_ sender: UIButton) {
        
        applyButton.setTitle("Submitted", for: .normal)
        applyButton.backgroundColor = .NaturianColor.lightGray2
        
        selectedArticle.didApplyID.append(userID ?? "" )
        
        userModels.appliedTalent.append(selectedArticle.talentPostID)
        
        userManager.updateAppliedTalent(userModel: userModels, userID: userID ?? "" )
        
        talentManager.updateData(applyTalent: selectedArticle)
    }
    
    @objc func didConatact() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {
            
            fatalError("can't find ChatViewController")
        }
        
        vc.chatToID = selectedArticle.userID
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func addToCollection(_ sender: UIButton) {
        
        if sender.isSelected == false {
            
            sender.isSelected = true
            setupLottie()
            
            userManager.addLikedTelent(uid: self.userID ?? "",
                                       talentID: self.selectedArticle.talentPostID ?? "") { [weak self] result in
                
                switch result {
                    
                case .success:
//                    self?.tabBarController?.tabBar.isHidden = true
                    print("success")

                case .failure:
                    print("can't fetch data")
                }
            }
        } else {

            sender.isSelected = false

            userManager.removeLikedTelent(uid: self.userID ?? "",
                                          talentID: self.selectedArticle.talentPostID ?? "") { [weak self] result in
                switch result {

                case .success:
//                    self?.tabBarController?.tabBar.isHidden = true
                    print("success")

                case .failure:
                    print("can't fetch data")

                }
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("tapImage")
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {
            
            fatalError("can't find ChatViewController")
        }
        
        vc.chatToID = selectedArticle.userID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func switchButtonState() {
        
        if selectedArticle.userID == userID {
            
            applyButton.backgroundColor = .NaturianColor.navigationGray
            applyButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 16)
            applyButton.setTitleColor(.white, for: .normal)
            applyButton.lkCornerRadius = 24
            applyButton.isEnabled = false
            applyButton.lkBorderWidth = 0
            applyButton.alpha = 0.5
            
        } else {
            return
        }
    }
}

extension TalentDetailViewController {
    
    func setUp() {
        
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        tableView.register(TalentDetailTVCell.self, forCellReuseIdentifier: TalentDetailTVCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        //        postPhotoImage.isUserInteractionEnabled = true
        applyButton.addTarget(self, action: #selector(didApply(_:)), for: .touchUpInside)
        //        contactButton.addTarget(self, action: #selector(didConatact), for: .touchUpInside)
    }
    
    func style() {
        
        closeButton.setImage(UIImage(named: "back_white"), for: .normal)
        
        applyButton.setTitle("Submit", for: .normal)
        applyButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        applyButton.lkCornerRadius = 10
        applyButton.backgroundColor = .NaturianColor.treatmentGreen
        
        if selectedArticle.userID == self.userID {
            applyButton.backgroundColor = .NaturianColor.navigationGray
            applyButton.alpha = 0.6
            applyButton.isEnabled = false
        }
        
        seedValue.font =  UIFont(name: Roboto.bold.rawValue, size: 26)
        seedValue.textAlignment = .left
        seedValue.text = String(describing: selectedArticle.seedValue ?? 0)
        seedValue.textColor = .NaturianColor.darkGray
        
        seedIcon.image = UIImage(named: "seedgray")
        seedStack.axis = .horizontal
        seedStack.alignment = .center
        seedStack.spacing = 6
        
        bottomView.backgroundColor = .white
        bottomView.lkBorderWidth = 1
        bottomView.lkBorderColor = .NaturianColor.navigationGray
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
//        guard let appliedID = self.selectedArticle.didApplyID else { return }
        
        if self.selectedArticle.didApplyID.contains(self.userID ?? "") {
            applyButton.isSelected = true
            applyButton.setTitle("Submitted", for: .normal)
            applyButton.backgroundColor = .NaturianColor.lightGray2
            applyButton.isEnabled = false
        } else {
            applyButton.isSelected = false
            applyButton.setTitle("Submit", for: .normal)
            applyButton.isEnabled = true
        }
    }
    
    func layout() {
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(applyButton)
        tableView.addSubview(closeButton)
        view.addSubview(tableView)
        view.addSubview(bottomView)
        
        bottomView.addSubview(seedStack)
        seedStack.addArrangedSubview(seedIcon)
        seedStack.addArrangedSubview(seedValue)
        
        NSLayoutConstraint.activate([
            
            applyButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15),
            applyButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -24),
            applyButton.widthAnchor.constraint(equalToConstant: 136),
            applyButton.heightAnchor.constraint(equalToConstant: 42),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1),
            bottomView.heightAnchor.constraint(equalToConstant: 90),
            
            seedStack.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 24),
            seedStack.topAnchor.constraint(equalTo: applyButton.topAnchor),
            
            seedIcon.widthAnchor.constraint(equalToConstant: 34),
            seedIcon.heightAnchor.constraint(equalToConstant: 34),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
}

extension TalentDetailViewController: UITableViewDelegate {
    
}

extension TalentDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TalentDetailTVCell.identifer,
                                                       for: indexPath) as? TalentDetailTVCell else { fatalError("can't find Cell") }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        cell.avatarImage.isUserInteractionEnabled = true
        cell.avatarImage.addGestureRecognizer(tapGestureRecognizer)
        
        cell.titleText.text = selectedArticle.title
        cell.providerName.text = selectedArticle.userInfo?.name
        cell.locationLabel.text = selectedArticle.location
        cell.categoryBTN.setTitle(String(describing: selectedArticle.category ?? ""), for: .normal)
        
        cell.descriptionText.text = selectedArticle.content?.replacingOccurrences(of: "\\n", with: "\n")
//        cell.descriptionText.text = selectedArticle.content
        
        let postUrl = URL(string: selectedArticle.images[0])
        cell.postPhotoImage.kf.setImage(with: postUrl)
        
        let avatarUrl = URL(string: selectedArticle.userInfo?.userAvatar ?? "")
        cell.avatarImage.kf.setImage(with: avatarUrl)
        
        cell.layoutIfNeeded()
        cell.postPhotoImage.clipsToBounds = true
        cell.avatarImage.clipsToBounds = true
        cell.avatarImage.contentMode = .scaleAspectFill
        cell.postPhotoImage.contentMode = .scaleAspectFill
        cell.contactBtn.addTarget(self, action: #selector(didConatact), for: .touchUpInside)
        
        guard let likedID = self.selectedArticle.talentPostID else { return UITableViewCell() }
        
        if self.userModels.likedTalentList.contains(likedID) {
            cell.likedBtn.isSelected = true
        } else {
            cell.likedBtn.isSelected = false
        }
        
        cell.likedBtn.clipsToBounds = true
        cell.likedBtn.contentMode = .scaleAspectFit
        cell.likedBtn.addTarget(self, action: #selector(addToCollection(_:)), for: .touchUpInside)
        
        cell.moreBtn.menu = UIMenu(children: [
            UIAction(title: "Block User",
                     image: UIImage(named: "block"), handler: { action in
                         
                         self.userManager.addBlockList(uid: self.userID ?? "",
                                                       blockID: self.selectedArticle.userID ?? "") { [weak self] result in
                             switch result {
                                 
                             case .success:
                                 self?.dismiss(animated: true)
                                 
                             case .failure:
                                 print("can't fetch data")
                                 
                             }
                         }
                     }),
            
            UIAction(title: "Report User",
                     image: UIImage(named: "report"), handler: { action in
                         print("Report User")
                     })
        ])
        
        if selectedArticle.userID == self.userID {
            
            cell.contactBtn.isHidden = true
        }
        
        switch selectedArticle.userInfo?.gender {
            
        case "Male":
            cell.genderIcon.image = UIImage(named: "male")
        case "Female":
            cell.genderIcon.image = UIImage(named: "female")
        case "Undefined":
            cell.genderIcon.image = UIImage(named: "undefined")
        default:
            break
        }
        
        return cell
    }
}
