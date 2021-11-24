//
//  PetCollectionViewCell.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.11.21.
//

import UIKit

class PetCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "PetCollectionViewCell"
    
    //    let name: UILabel = {
    //        let dogName = UILabel()
    //        dogName.text = "Hello"
    //        return dogName
    //    }()
    
    private let name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "BackgroundCell")
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3.5
        layer.cornerRadius = 10.0
        
        contentView.addSubview(name)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    var nameText: String = "" {
        didSet {
            name.text = nameText
        }
    }
}

