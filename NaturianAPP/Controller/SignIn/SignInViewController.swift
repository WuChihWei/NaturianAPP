//
//  SignInViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/28.
//

import UIKit
import FirebaseAuth // 用來與 Firebase Auth 進行串接用的
import AuthenticationServices // Sign in with Apple 的主體框架
import CryptoKit // 用來產生隨機字串 (Nonce) 的
import Firebase
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    static let shared = SignInViewController()
    var userManager = UserManager()
    var userInfo: UserModel!
    
    let termsOfUseLB = UILabel()
    let termsOfUseBtn = UIButton()
    let firstStack = UIStackView()
    let secondStack = UIStackView()
    
    let andLB = UILabel()
    let privacyPolicyBtn = UIButton()
    
    var uuid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        policy()
        setup()
        
        setSignInWithAppleBtn()
        observeAppleIDState()
        checkAppleIDCredentialState(userID: uuid ?? "")
        
        Auth.auth().addStateDidChangeListener { (auth, user) in if user != nil {
            
            guard let vc = self.storyboard?.instantiateViewController(
                withIdentifier: "AccountViewController") as? AccountViewController else {
                
                fatalError("can't find AccountViewController")
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            self.checkAppleIDCredentialState(userID: self.uuid ?? "")
            
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func presentEula() {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "EULAVC") as? EULAVC else {
            fatalError("can't find EULAVC")
        }
        present(vc, animated: true)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func presentPolicy() {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyVC else {
            fatalError("can't find PrivacyPolicyVC")
        }
        present(vc, animated: true)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setup() {
        termsOfUseBtn.addTarget(self, action: #selector(presentEula), for: .touchUpInside)
        privacyPolicyBtn.addTarget(self, action: #selector(presentPolicy), for: .touchUpInside)
    }
    
    func policy() {
        
        termsOfUseLB.text = "By signing up you accept the"
        termsOfUseLB.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        termsOfUseLB.textColor = .darkGray
        
        termsOfUseBtn.setTitle("Terms of Use", for: .normal)
        termsOfUseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        termsOfUseBtn.setTitleColor(.NaturianColor.exerciseBlue, for: .normal)
        
        andLB.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        andLB.text = "and"
        andLB.textColor = .darkGray
        
        privacyPolicyBtn.setTitle("Privacy Policy", for: .normal)
        privacyPolicyBtn.setTitleColor(.NaturianColor.exerciseBlue, for: .normal)
        privacyPolicyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        firstStack.axis = .horizontal
        firstStack.alignment = .center
        firstStack.spacing = 4
        
        secondStack.axis = .horizontal
        secondStack.alignment = .center
        secondStack.spacing = 4
        
        firstStack.addArrangedSubview(termsOfUseLB)
        firstStack.addArrangedSubview(termsOfUseBtn)
        
        secondStack.addArrangedSubview(andLB)
        secondStack.addArrangedSubview(privacyPolicyBtn)
        
        firstStack.translatesAutoresizingMaskIntoConstraints = false
        secondStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(firstStack)
        view.addSubview(secondStack)
    }
    
    // MARK: - 在畫面上產生 Sign in with Apple 按鈕
    func setSignInWithAppleBtn() {
        let signInWithAppleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                              authorizationButtonStyle: chooseAppleButtonStyle())
        view.addSubview(signInWithAppleBtn)
        signInWithAppleBtn.cornerRadius = 25
        signInWithAppleBtn.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        signInWithAppleBtn.translatesAutoresizingMaskIntoConstraints = false
        signInWithAppleBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInWithAppleBtn.widthAnchor.constraint(equalToConstant: 300).isActive = true
        signInWithAppleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        signInWithAppleBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        
        signInWithAppleBtn.lkBorderWidth = 1
        signInWithAppleBtn.lkCornerRadius = 25
        
        NSLayoutConstraint.activate([
            
            firstStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstStack.topAnchor.constraint(equalTo: signInWithAppleBtn.bottomAnchor, constant: 20),
            firstStack.heightAnchor.constraint(equalToConstant: 14),
            
            //            secondStack.topAnchor.constraint(equalTo: firstStack.bottomAnchor, constant: 4),
            secondStack.heightAnchor.constraint(equalToConstant: 14),
            secondStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondStack.topAnchor.constraint(equalTo: firstStack.bottomAnchor, constant: 10)
        ])
    }
    
    func chooseAppleButtonStyle() -> ASAuthorizationAppleIDButton.Style {
        return (UITraitCollection.current.userInterfaceStyle == .light) ? .white : .white // 淺色模式就顯示黑色的按鈕，深色模式就顯示白色的按鈕
    }
    
    // MARK: - Sign in with Apple 登入
    fileprivate var currentNonce: String?
    
    @objc func signInWithApple() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        // 登入成功
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                CustomFunc.customAlert(title: "", message: "Unable to fetch identity token",
                                       vc: self, actionHandler: nil)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                CustomFunc.customAlert(title: "",
                                       message: "Unable to serialize token string from data\n\(appleIDToken.debugDescription)",
                                       vc: self, actionHandler: nil)
                return
            }
            // 產生 Apple ID 登入的 Credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            // 與 Firebase Auth 進行串接
            firebaseSignInWithApple(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 登入失敗，處理 Error
        switch error {
        case ASAuthorizationError.canceled:
            CustomFunc.customAlert(title: "使用者取消登入", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.failed:
            CustomFunc.customAlert(title: "授權請求失敗", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.invalidResponse:
            CustomFunc.customAlert(title: "授權請求無回應", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.notHandled:
            CustomFunc.customAlert(title: "授權請求未處理", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.unknown:
            CustomFunc.customAlert(title: "授權失敗，原因不知", message: "", vc: self, actionHandler: nil)
        default:
            break
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
// 在畫面上顯示授權畫面
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension SignInViewController {
    // MARK: - 透過 Credential 與 Firebase Auth 串接
    func firebaseSignInWithApple(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            guard error == nil else {
                CustomFunc.customAlert(title: "", message: "\(String(describing: error!.localizedDescription))", vc: self, actionHandler: nil)
                return
            }
            
            //            let currentUser = Auth.auth().currentUser
            let userID = Auth.auth().currentUser?.uid
            let email = Auth.auth().currentUser?.email
            
            
            guard let userid = userID else { return }
            
            
            self.userManager.fetchUserData(userID: userid) { result in
                
                switch result {
                    
                case .success:
                    
                    CustomFunc.customAlert(title: "登入成功！", message: "", vc: self, actionHandler: self.getFirebaseUserInfo)
                    
                    guard let vc = self.storyboard?.instantiateViewController(
                        withIdentifier: "AccountViewController") as? AccountViewController else {
                        
                        fatalError("can't find AccountViewController")
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .failure:
                    
                    self.userManager.addUser(name: "", userID: userID ?? "", email: email ?? "")
                    
                    CustomFunc.customAlert(title: "登入成功！", message: "", vc: self, actionHandler: self.getFirebaseUserInfo)
                    
                    guard let vc = self.storyboard?.instantiateViewController(
                        withIdentifier: "AccountViewController") as? AccountViewController else {
                        
                        fatalError("can't find AccountViewController")
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
            let db = Firestore.firestore().collection("users")
            
            db.whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
                
                if let doc = querySnapshot?.documents.first {
                    
                    print("exist")
                } else {
                    self.userManager.addUser(name: "", userID: userID ?? "", email: email ?? "")
                }
            }
        }
    }
    
    // MARK: - Firebase 取得登入使用者的資訊
    func getFirebaseUserInfo() {
        let currentUser = Auth.auth().currentUser
        //        print(currentUser)
        guard let user = currentUser else {
            CustomFunc.customAlert(title: "無法取得使用者資料！", message: "", vc: self, actionHandler: nil)
            return
        }
        
        let uid = user.uid
        let email = user.email
        let db = Firestore.firestore().collection("users")
        
        db.whereField("userID", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            
            if let doc = querySnapshot?.documents.first {
                print("exist")
            } else {
                
                self.userManager.addUser(name: "", userID: uid, email: email ?? "")
            }
        }
        
        SignInViewController.shared.uuid = user.uid
        
    }
    
    // MARK: - 監聽目前的 Apple ID 的登入狀況
    // 主動監聽
    func checkAppleIDCredentialState(userID: String) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { credentialState, error in
            switch credentialState {
            case .authorized:
                CustomFunc.customAlert(title: "使用者已授權！", message: "", vc: self, actionHandler: nil)
            case .revoked:
                CustomFunc.customAlert(title: "使用者憑證已被註銷！", message: "請到\n「設定 → Apple ID → 密碼與安全性 → 使用 Apple ID 的 App」\n將此 App 停止使用 Apple ID\n並再次使用 Apple ID 登入本 App！", vc: self, actionHandler: nil)
                //            case .notFound:
                //                CustomFunc.customAlert(title: "", message: "使用者尚未使用過 Apple ID 登入！", vc: self, actionHandler: nil)
            case .transferred:
                CustomFunc.customAlert(title: "請與開發者團隊進行聯繫，以利進行使用者遷移！", message: "", vc: self, actionHandler: nil)
            default:
                break
            }
        }
    }
    
    // 被動監聽 (使用 Apple ID 登入或登出都會觸發)
    func observeAppleIDState() {
        
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
                                               object: nil,
                                               queue: nil) { (notification: Notification) in
            CustomFunc.customAlert(title: "使用者登入或登出",
                                   message: "",
                                   vc: self,
                                   actionHandler: nil)
        }
    }
}

extension SignInViewController {
    
    func userState() {
        
        userManager.fetchUserData(userID: uuid ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.userInfo = userModel
                
                print(self?.userInfo ?? "")
                DispatchQueue.main.async {
                    
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
}
