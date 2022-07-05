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
    
    var userFirebaseManager = UserFirebaseManager()
    
    //    var chatTalentID: String = ""
    
    var db = Firestore.firestore()
    
    private var docReference: DocumentReference?
    
    //    private let currentUser = Auth.auth().currentUser?.uid
    let currentUser = "2"
    
    var chatToID: String?
    
    var messages: [Message] = []
    
    var chatToTalentModel: TalentArticle!
    
    var currentUserModel: UserModel!
    
    //    guard let user2Name = chatToTalentModel.userInfo?.name else {return}
    
    //    var currentUser: String? = "321"
    //    var currentUser: String? = "123333"
    //    var user2UID: String? = "123333"
    //    var user2Name: String? = "Hello World"
    
    var currentUserImageUrl: URL?
    
    // var user2ImageUrl: String? = "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80"
    
    //    var currentUser: User = Auth.auth().currentUser!
    //        var user2UID: String? = "3213333"
    //    var currentUser: String? = "2"
    //    var currentUserImageUrl: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userState()
        
        guard let user2Name = chatToTalentModel.userInfo?.name else {return}
        //
        self.title = user2Name
        
        navigationItem.largeTitleDisplayMode = .never
        
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        loadChat()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        changeIsReadState()
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
    
    func userState() {
        
        userFirebaseManager.fetchUserData(userID: currentUser ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.currentUserModel = userModel
                
                self?.currentUserImageUrl  = self?.currentUserModel?.userAvatar ?? URL(string: "")!
                
                print(self?.currentUserModel ?? "")
                DispatchQueue.main.async {
                    
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    //    func changeIsReadState() {
    //
    //        let docID = db.collection("thread").document().documentID
    //
    //        docReference?.collection("thread").document(docID).updateData(["isRead": true]) { err in
    //            if let err = err {
    //                print("Error updating document: \(err)")
    //            } else {
    //                print("Document successfully updated")
    //                print(docID)
    //            }
    //        }
    //    }
    
    func loadChat() {
        
        guard let user2UID = chatToTalentModel.userID else {return}
        
        guard let chatTalentID = chatToTalentModel.talentPostID else {return}
        
        let db = Firestore.firestore().collection("chats").whereField("users", arrayContainsAny: [user2UID]).whereField("chatTalentID", isEqualTo: chatTalentID)
        
        db.getDocuments { (chatQuerySnap, error) in
            
            if let error = error {
                
                print("Error: \(error)")
                return
                
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else {
                    
                    return
                }
                
                if queryCount == 0 {
                    self.createNewChat() }
                else if queryCount >= 1 {
                    
                    // Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Chat(dictionary: doc.data())
                        
                        // //Get the chat which has user2 id
                        if (chat?.users.contains(user2UID )) == true {
                            
                            self.docReference = doc.reference
                            
                            // fetch it's thread collection
                            doc.reference.collection("thread").order(by: "created",
                                                                     descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                
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
        guard let user2ID = chatToTalentModel.userID else {return}
        
        guard let chatTalentID = self.chatToTalentModel.talentPostID else {return}
        
        let users = [self.currentUser, user2ID]
        
        let data: [String: Any] = [ "users": users, "chatTalentID": chatTalentID]
        let db = Firestore.firestore().collection("chats")
        //        let chatroomID = db.
        
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
            id: currentUser ,
            content: text,
            created: Timestamp(),
            //                         senderID: currentUser.uid,
            senderID: currentUser ,
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
        // return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
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
        guard let currentUserImageUrl = currentUserModel.userAvatar else {return}
        
        //        if message.sender.senderId == currentUser.uid
        if message.sender.senderId == currentUser {
            SDWebImageManager.shared.loadImage(
                //  with: currentUser.photoURL,
                with: currentUserImageUrl,
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    
                    avatarView.image = image
                }
        } else {
            
            guard let user2ImageUrl = chatToTalentModel.userInfo?.userAvatar else {return}
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
