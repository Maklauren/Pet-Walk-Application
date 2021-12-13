//
//  PetProfileCollectionView.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 7.12.21.
//

import UIKit
import RxSwift

class PetProfileCollectionView: UICollectionViewCell {
    
    static var identifier = "PetProfileCollectionView"
    
    private let image = UIImageView()
    private let doggieID = UILabel()
    
    private let petRepository = PetRepository()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "Background")
        
        contentView.addSubview(image)
        
        [image].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        image.layer.borderWidth = 4
        image.layer.borderColor = UIColor.white.cgColor
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
                    self.image.image = $0
                })
                .disposed(by: disposeBag)
        }
    }
    
    var ididid: String = "" {
        didSet {
            doggieID.text = ididid
        }
    }
}

