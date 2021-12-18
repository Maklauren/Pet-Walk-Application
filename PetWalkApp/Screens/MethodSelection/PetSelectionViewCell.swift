//
//  PetSellectionViewCell.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 30.11.21.
//

import UIKit
import RxSwift

class PetSelectionViewCell: UICollectionViewCell {
    
    static var identifier = "PetSelectionViewCell"
    
    private let dogImage = UIImageView()
    private let dogName = UILabel()
    
    private let petRepository = PetRepository()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "Background")
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3.5
        layer.cornerRadius = 10.0
        
        contentView.addSubview(dogImage)
        contentView.addSubview(dogName)
        
        [dogImage, dogName].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            dogImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dogImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dogImage.widthAnchor.constraint(equalToConstant: 80),
            dogImage.heightAnchor.constraint(equalToConstant: 80),
            
            dogName.centerXAnchor.constraint(equalTo: dogImage.centerXAnchor),
            dogName.topAnchor.constraint(equalTo: dogImage.bottomAnchor, constant: 4)
        ])
        
        dogImage.contentMode = .scaleAspectFill
        dogImage.layer.cornerRadius = 40
        dogImage.clipsToBounds = true
        dogImage.layer.borderWidth = 4
        dogImage.layer.borderColor = UIColor.white.cgColor
        
        dogName.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.semibold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    var nameText: String = "" {
        didSet {
            dogName.text = nameText
        }
    }
}
