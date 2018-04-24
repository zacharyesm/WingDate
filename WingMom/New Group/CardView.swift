//
//  CardView.swift
//  WingMom
//
//  Created by Zack Esm on 4/21/18.
//  Copyright © 2018 Hackchella. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var user: User!
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .green
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = .white
        return lbl
    }()
    
    let ageLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = .white
        return lbl
    }()
    
    let jobLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = .white
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        
        clipsToBounds = true
        
        layer.cornerRadius = 10
        
        let margins = layoutMarginsGuide
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        
        addSubview(jobLabel)
        jobLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -5).isActive = true
        jobLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        jobLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(ageLabel)
        ageLabel.bottomAnchor.constraint(equalTo: jobLabel.topAnchor, constant: -5).isActive = true
        ageLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: ageLabel.topAnchor, constant: -5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func configureView(user: User) {
        self.user = user
        
        if let url = URL(string: user.imageUrl) {
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                imageView.image = image
            }
        }
        
        nameLabel.text = user.name
        ageLabel.text = "\(user.age ?? 25)"
        jobLabel.text = user.job
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
