//
//  FacebookService.swift
//  WingMom
//
//  Created by Zack Esm on 4/21/18.
//  Copyright © 2018 Hackchella. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookService {
    static let fbs = FacebookService()
    
    func getUserPhotoLarge(facebookID: String, completion: @escaping (_ photoURL: String?) -> Void) {
        FBSDKGraphRequest(graphPath: facebookID, parameters: ["fields" : "picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                if let dict = result as? Dictionary<String, AnyObject>{
                    if let photoDict = dict["picture"]?["data"] as? Dictionary<String, AnyObject>{
                        if let url = photoDict["url"] as? String {
                            completion(url)
                        }
                    }
                }
            } else {
                print(error ?? "Error")
                completion(nil)
            }
        })
    }
    
}
