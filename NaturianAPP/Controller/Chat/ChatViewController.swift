//
//  ChatViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import SDWebImage
import FirebaseAuth
import IQKeyboardManagerSwift

class ChatViewController: MessagesViewController {
    
    var userFirebaseManager = UserManager()
    
    var db = Firestore.firestore()
    
    private var docReference: DocumentReference?
    
    private let currentUser = Auth.auth().currentUser?.uid
    //    let currentUser = "2"
    //        let currentUser = "1"
    
    var chatToID: String?
    
    var messages: [Message] = []
    
    var chatToUserModel: UserModel!
    
    var currentUserModel: UserModel!
    
    var currentUserImageUrl: URL?
    
    var user2ImageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        currentUserInfo()
        chatToUserInfo()
        
        navigationController?.navigationBar.isHidden = false
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        changeIsReadState()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear( _ animated: Bool) {
        super.viewDidAppear(animated)
        // disable iq keyboard
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidDisappear( _ animated: Bool) {
        super.viewDidDisappear(animated)
        // enable iq keyboard
        IQKeyboardManager.shared.enable = true
    }
    
    func style() {
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back_frame"),
                                         style: .done,
                                         target: self,
                                         action: #selector(backTapped))
        //        let backButton = UIBarButtonItem(title: "<",
        //                                         style: .done,
        //                                         target: self,
        //                                         action: #selector(backTapped))
        
        backButton.tintColor = .NaturianColor.navigationGray
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem?.title = ""
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func currentUserInfo() {
        
        userFirebaseManager.fetchUserData(userID: currentUser ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.currentUserModel = userModel
                
                let url = URL(string: self?.currentUserModel?.userAvatar ?? "")
                self?.currentUserImageUrl = url
                
                print(self?.currentUserModel ?? "")
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    func chatToUserInfo() {
        
        userFirebaseManager.fetchUserData(userID: chatToID ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.chatToUserModel = userModel
                
                let url = URL(string: self?.chatToUserModel?.userAvatar ?? "")
                self?.user2ImageUrl  = url
                
                self?.title  = self?.chatToUserModel?.name ?? ""
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    func loadChat() {
        
        let db = Firestore.firestore().collection("chats").whereField("users",
                                                                      arrayContains: self.currentUser as Any)
        db.getDocuments { (chatQuerySnap, error) in
            
            if let error = error {
                
                print("Error: \(error)")
                return
                
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else {
                    
                    return
                }
                
                if queryCount == 0 { self.createNewChat() }
                
                else if queryCount >= 1 {
                    
                    // Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Chat(dictionary: doc.data())
                        
                        // Get the chat which has user2 id
                        if chat?.users.contains(self.chatToID ?? "ID Not Found") == true {
                            
                            self.docReference = doc.reference
                            
                            // fetch it's thread collection
                            doc.reference.collection("thread").order(by: "created",
                                                                     descending: false).addSnapshotListener(includeMetadataChanges: true,
                                                                                                            listener: { (threadQuery, error) in
                                                                         
                                                                         if let error = error {
                                                                             print("Error: \(error)")
                                                                             return
                                                                             
                                                                         } else {
                                                                             self.messages.removeAll()
                                                                             for message in threadQuery!.documents {
                                                                                 let msg = Message(dictionary: message.data())
                                                                                 self.messages.append(msg!)
                                                                                 print("Data: \(msg?.content ?? "No message found")")
                                                                             }
                                                                             // We'll edit viewDidload below which will solve the error
                                                                             self.messagesCollectionView.reloadData()
                                                                             self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                                                                         }
                                                                     })
                            return
                        } // end of if
                    } // end of for
                    
                    self.createNewChat()
                    
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }
    
    func createNewChat() {
        
        //        let users = [self.currentUser.uid, self.user2UID]
        
        let users = [self.currentUser, self.chatToID]
        print(users)
        
        let data: [String: Any] = [ "users": users]
        let db = Firestore.firestore().collection("chats")
        
        db.addDocument(data: data) { (error) in
            
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat()
            }
        }
    }
    
    func insertNewMessage(_ message: Message) {
        
        // add the message to the messages array and reload it
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    func save(_ message: Message) {
        
        // Preparing the data as per our firestore collection
        let data: [String: Any] = [
            
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName,
            "isRead": message.isRead
        ]
        // Writing it to the thread using the saved document reference we saved in load chat function
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        })
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    // When use press send button this method is called.
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = Message(
            //            id: UUID().uuidString,
            //                         id: UUID().uuidString,
            id: currentUser ?? "" ,
            content: text,
            created: Timestamp(),
            //                         senderID: currentUser.uid,
            senderID: currentUser ?? "" ,
            //                              senderName: currentUser.displayName!
            senderName: "currentUser.displayName!",
            isRead: false
        )
        // calling function to insert and save message
        insertNewMessage(message)
        save(message)
        
        // clearing input field
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        // messagesCollectionView.scrollToBottom(animated: true)
    }
}
extension ChatViewController: MessagesDataSource {
    
    // This method return the current sender ID and name
    func currentSender() -> SenderType {
        
        return ChatUser(
            //            senderId: Auth.auth().currentUser!.uid,
            senderId: currentUser ?? "",
            //            displayName: (Auth.auth().currentUser?.displayName)!
            displayName: "currentUser.displayName!"
        )
        // return Sender(id: Auth.auth().currentUser!.uid,
        //    displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
    }
    // This return the MessageType which we have defined to be text in Messages.swift
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    // Return the total number of messages
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if messages.count == 0 {
            print("There are no messages")
            return 0
        } else {
            return messages.count
        }
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType,
                    at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return .zero
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    // Background colors of the bubbles
    func backgroundColor(for message: MessageType,
                         at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? UIColor(red: 50/255,
                                                               green: 205/255,
                                                               blue: 50/255,
                                                               alpha: 1) : .lightGray
    }
    // THis function shows the avatar
    func configureAvatarView(_ avatarView: AvatarView,
                             for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) {
        // If it's current user show current user photo.
        guard let currentUserImageUrl = URL(string: currentUserModel.userAvatar ?? "") else {return}
        
        //        if message.sender.senderId == currentUser.uid
        if message.sender.senderId == currentUser {
            SDWebImageManager.shared.loadImage(
                //                  with: currentUser.photoURL,
                with: currentUserImageUrl,
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    
                    avatarView.image = image
                }
        } else {
            
            //            guard let user2ImageUrl = chatToTalentModel.userInfo?.userAvatar else {return}
            SDWebImageManager.shared.loadImage(with: user2ImageUrl,
                                               options: .highPriority,
                                               progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        }
    }
    // Styling the bubble to have a tail
    func messageStyle(for message: MessageType,
                      at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}
