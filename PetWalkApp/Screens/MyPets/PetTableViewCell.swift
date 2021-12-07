//
//  PetCellView.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.11.21.
//

import UIKit
import RxSwift

class PetTableViewCell: UITableViewCell {
    
    static var identifier = "PetTableViewCell"
    
    private let dogImage = UIImageView()
    private let breed = UILabel()
    private let name = UILabel()
    private var age = UILabel()
    private let infoButton = UIImageView()
    
    private let petRepository = PetRepository()
    
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dogImage)
        contentView.addSubview(breed)
        contentView.addSubview(name)
        contentView.addSubview(age)
        contentView.addSubview(infoButton)
        
        [dogImage, breed, name, age, infoButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            dogImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dogImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dogImage.widthAnchor.constraint(equalToConstant: 80),
            dogImage.heightAnchor.constraint(equalToConstant: 80),
            
            breed.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            breed.leadingAnchor.constraint(equalTo: dogImage.trailingAnchor, constant: 8),
            
            name.topAnchor.constraint(equalTo: breed.bottomAnchor, constant: 0),
            name.leadingAnchor.constraint(equalTo: dogImage.trailingAnchor, constant: 8),
            
            age.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0),
            age.leadingAnchor.constraint(equalTo: dogImage.trailingAnchor, constant: 8),
            
            infoButton.leadingAnchor.constraint(equalTo: dogImage.trailingAnchor, constant: 250),
            infoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.backgroundColor = UIColor(named: "BackgroundCell")
        
        dogImage.contentMode = .scaleAspectFill
        dogImage.layer.cornerRadius = 40
        dogImage.clipsToBounds = true
        dogImage.layer.borderWidth = 4
        dogImage.layer.borderColor = UIColor.white.cgColor
        
        breed.textColor = UIColor(named: "Text")
        breed.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        
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
    
    var dogID: String = "" {
        didSet {
            petRepository.downloadAvatar(selectedDogID: dogID)
                .subscribe(onSuccess: {
                    self.dogImage.image = $0
                })
                .disposed(by: disposeBag)
        }
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
