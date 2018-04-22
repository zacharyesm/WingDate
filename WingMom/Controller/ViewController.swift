//
//  ViewController.swift
//  WingMom
//
//  Created by Zack Esm on 4/21/18.
//  Copyright © 2018 Hackchella. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class ViewController: UIViewController {
    
    let logoImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Logo_White"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoImage)
        logoImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let loginButton = FBSDKLoginButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile"]
        
        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
    }
    
}

extension ViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("LOGGING USER OUT.")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            if let user = user, let facebookID = result.token.userID {
                
                FacebookService.fbs.getUserPhotoLarge(facebookID: facebookID, completion: { (url) in
                    let userData = [
                        "name": user.displayName,
                        "imageUrl": url ?? ""
                    ]
                    
                    FirebaseService.fs.createFirebaseUser(facebookID: facebookID, user: userData as! Dictionary<String, String>)
                    UserDefaults.standard.set(facebookID, forKey: "facebookId")
                    
                    let vc = MatchSwipeVC()
                    self.present(vc, animated: true, completion: nil)
                    
                })

            }
        }
            
    }
    
}
