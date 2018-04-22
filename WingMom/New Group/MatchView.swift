//
//  MatchView.swift
//  WingMom
//
//  Created by Zack Esm on 4/22/18.
//  Copyright © 2018 Hackchella. All rights reserved.
//

import UIKit

class MatchView: UIView {

    var backgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.alpha = 0.6
        return v
    }()
    
    var dialogView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    var matchLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "IT'S A MATCH"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    convenience init(title:String) {
        self.init(frame: UIScreen.main.bounds)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(dialogView)
        dialogView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        dialogView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        dialogView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dialogView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        dialogView.addSubview(matchLabel)
        matchLabel.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor).isActive = true
        matchLabel.centerYAnchor.constraint(equalTo: dialogView.centerYAnchor).isActive = true
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
//        addGestureRecognizer(tap)
        
    }
    
//    @objc func close() {
//        dismiss(animated: true)
//    }

}
