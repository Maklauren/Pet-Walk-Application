//
//  PetCellView.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.11.21.
//

import UIKit

class PetCellView: UITableViewCell {

    private let image = UIImageView()
    private let breed = UILabel()
    private let name = UILabel()
    private let age = UILabel()
    private let infoButton = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(image)
        contentView.addSubview(breed)
        contentView.addSubview(name)
        contentView.addSubview(age)
        contentView.addSubview(infoButton)

        [image, breed, name, age, infoButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80),
            
            breed.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            breed.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            
            name.topAnchor.constraint(equalTo: breed.bottomAnchor, constant: 0),
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            
            age.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0),
            age.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            
            infoButton.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 250),
            infoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.backgroundColor = UIColor(named: "BackgroundCell")
        
        image.image = UIImage(named: "DefaultDog")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 40
        image.clipsToBounds = true
        image.layer.borderWidth = 5.0
        image.layer.borderColor = UIColor.white.cgColor
        
        breed.textColor = UIColor(named: "Text")
        breed.font = UIFont.systemFont(ofSize: 16)
        
        name.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
        
        age.text = "No age information"
        age.textColor = UIColor(named: "Text")
        age.font = UIFont.systemFont(ofSize: 16)
        
        infoButton.image = UIImage(named: "InfoButton")
        infoButton.contentMode = .scaleAspectFill
        infoButton.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
    }

    var breedText: String = "" {
        didSet {
            breed.text = breedText
        }
    }
    
    var nameText: String = "" {
        didSet {
            name.text = nameText
        }
    }
    
    var ageText: String = "" {
        didSet {
            name.text = ageText
        }
    }
}
