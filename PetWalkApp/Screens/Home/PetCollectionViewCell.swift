//
//  PetCollectionViewCell.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.11.21.
//

import UIKit
import RxSwift

class PetCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "PetCollectionViewCell"
    
    private let image = UIImageView()
    private let name = UILabel()
    private let breed = UILabel()
    private let age = UILabel()
    private let moodButton = UIImageView()
    private let moodStatus = UILabel()
    
    private let petRepository = PetRepository()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "Background")
        
        contentView.addSubview(image)
        contentView.addSubview(name)
        contentView.addSubview(breed)
        contentView.addSubview(age)
        contentView.addSubview(moodButton)
        contentView.addSubview(moodStatus)
        
        [image, name, breed, age, moodButton, moodStatus].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            moodButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -75),
            moodButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            
            moodStatus.topAnchor.constraint(equalTo: moodButton.bottomAnchor, constant: 0),
            moodStatus.centerXAnchor.constraint(equalTo: moodButton.centerXAnchor),
        ])
        
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 40
        image.clipsToBounds = true
        image.layer.borderWidth = 4
        image.layer.borderColor = UIColor.white.cgColor
        
        breed.textColor = UIColor(named: "Text")
        breed.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        
        name.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
        
        age.textColor = UIColor(named: "Text")
        age.font = UIFont.systemFont(ofSize: 16)
        
        moodButton.image = UIImage(named: "Mood")
        moodButton.contentMode = .scaleAspectFill
        moodButton.clipsToBounds = true
        
        moodStatus.textColor = UIColor(named: "Blue")
        moodStatus.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3.5
        self.layer.cornerRadius = 15.0
        
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 5.0, height: 8.0)
        self.layer.shadowColor = UIColor.white.cgColor
    }
    
    var dogID: String = "" {
        didSet {
            petRepository.downloadAvatar(selectedDogID: dogID)
                .subscribe(onSuccess: {
                    self.image.image = $0
                })
                .disposed(by: disposeBag)
        }
    }
    
    var nameText: String = "" {
        didSet {
            name.text = nameText
        }
    }
    
    var breedText: String = "" {
        didSet {
            breed.text = breedText
        }
    }
    
    var moodText: String = "" {
        didSet {
            if Int(moodText) ?? 0 > 2 {
                moodStatus.text = "Happy"
            } else {
                moodStatus.text = "Sad"
            }
        }
    }
    
    var ageText: Date = Date() {
        didSet {
            let today = NSDate()
            
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            
            let currentAge = gregorian.components([.year, .month, .day], from: ageText, to: today as Date, options: [])
            
            if currentAge.year == 0 {
                age.text = "\(currentAge.month!) months, \(currentAge.day!) days"
            } else if currentAge.month == 0 {
                age.text = "\(currentAge.year!) years, \(currentAge.day!) days"
            } else if currentAge.day == 0 {
                age.text = "\(currentAge.year!) years, \(currentAge.month!) months"
            } else if currentAge.year == 0 && currentAge.month == 0 {
                age.text = "\(currentAge.day!) days"
            } else if currentAge.year == 0 && currentAge.day == 0 {
                age.text = "\(currentAge.month!) months"
            } else if currentAge.month == 0 && currentAge.day == 0 {
                age.text = "\(currentAge.year!) years"
            } else {
                age.text = "\(currentAge.year!) years, \(currentAge.month!) months, \(currentAge.day!) days"
            }
        }
    }
}

