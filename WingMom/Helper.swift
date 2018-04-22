//
//  Helper.swift
//  WingMom
//
//  Created by Zack Esm on 4/21/18.
//  Copyright © 2018 Hackchella. All rights reserved.
//

import Foundation
import UIKit

func getStoryBoardVC(identifier: String) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: identifier)
    return vc
}

