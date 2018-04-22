//
//  FirebaseService.swift
//  WingMom
//
//  Created by Zack Esm on 4/21/18.
//  Copyright © 2018 Hackchella. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    static let fs = FirebaseService()
    
    private var _REF_USERS = Database.database().reference().child("users")
    private var _REF_MOMLIKES = Database.database().reference().child("momLikes")
//    private var _REF_FACEBOOK_USERS = Database.database().reference().child("userByFacebookID")
//    private var _REF_STORAGE = URL_STORAGE
//    private var _REF_POSTS = URL_BASE.child("posts")
//    private var _REF_CHATS = URL_BASE.child("chats")
    
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_MOMLIKES: DatabaseReference {
        return _REF_MOMLIKES
    }
    
//    var REF_FACEBOOK_USERS: DatabaseReference {
//        return _REF_FACEBOOK_USERS
//    }

    
//
//    var REF_STORAGE: FIRStorageReference {
//        return _REF_STORAGE
//    }
//
//    var REF_POSTS: FIRDatabaseReference {
//        return _REF_POSTS
//    }
//
//    var REF_CURRENT_USER: FIRDatabaseReference {
//        let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
//        let user = REF_USERS.child(uid)
//        print(uid)
//        return user
//    }
//
//
//    var REF_CHATS: FIRDatabaseReference {
//        return _REF_CHATS
//    }
    
    func createFirebaseUser(facebookID: String, user: Dictionary<String, String>) {
        REF_USERS.child(facebookID).child("account").updateChildValues(user)
    }
    
    func getUsers(_ completion: @escaping (_ result: [User]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                var users = [User]()
                for snap in snapshots {
                    if let dict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let user = User()
                        user.id = key
                        
                        if let account = dict["account"] as? [String: Any] {
                            user.name = account["name"] as? String
                            user.age = account["age"] as? Int
                            user.job = account["job"] as? String
                            user.imageUrl = account["imageUrl"] as? String
                        }
                        users.append(user)
                    }
                }
                completion(users)
            }
        })
    }
    
    func addToMotherLikes(userIds: [String]) {
        if let facebookId = UserDefaults.standard.string(forKey: "facebookId") {
            REF_MOMLIKES.updateChildValues([facebookId : userIds])
        }
    }
    
    func getMotherLikes(_ completion: @escaping (_ result: [User]) -> ()) {
        if let facebookId = UserDefaults.standard.string(forKey: "facebookId") {
            REF_MOMLIKES.child(facebookId).observeSingleEvent(of: .value, with: { snapshot in
                if let momLikes = snapshot.value as? [String] {
                    let userIds = Set(momLikes.map {$0})
                    print(userIds)
                    self.REF_USERS.observeSingleEvent(of: .value, with: { snapshot in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                            var users = [User]()
                            for snap in snapshots {
                                let key = snap.key
                                if !userIds.contains(key) { continue }
                                
                                if let dict = snap.value as? Dictionary<String, AnyObject> {
                                    
                                    let user = User()
                                    user.id = key
                                    
                                    if let account = dict["account"] as? [String: Any] {
                                        user.name = account["name"] as? String
                                        user.age = account["age"] as? Int
                                        user.job = account["job"] as? String
                                        user.imageUrl = account["imageUrl"] as? String
                                    }
                                    users.append(user)
                                }
                            }
                            completion(users)
                        }
                    })
                }
            })
        }
    }
}

