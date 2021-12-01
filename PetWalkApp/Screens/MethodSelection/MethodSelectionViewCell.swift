//
//  MethodSelectionViewCell.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 30.11.21.
//

import UIKit

class MethodSelectionViewCell: UITableViewCell {
    
    static var identifier = "MethodSelectionViewCell"
    
    private let methodText = UILabel()
    private var methodImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(methodText)
        contentView.addSubview(methodImage)
        
        [methodText, methodImage].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            methodText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            methodText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            methodImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            methodImage.centerYAnchor.constraint(equalTo: methodText.centerYAnchor),
            methodImage.heightAnchor.constraint(equalToConstant: 36),
            methodImage.widthAnchor.constraint(equalToConstant: 36),
        ])
        
        contentView.backgroundColor = UIColor(named: "BackgroundCell")
        
        methodText.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.semibold)
        methodText.textColor = UIColor.black
        
        methodImage.contentMode = .scaleAspectFill
        methodImage.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var method: String = "" {
        didSet {
            methodText.text = method
        }
    }
    
    var imageMethod: UIImage = UIImage() {
        didSet {
            methodImage.image = imageMethod
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            methodText.textColor = UIColor(named: "Blue")
            methodImage.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))?.withRenderingMode(.alwaysOriginal)            
        } else {
            methodText.textColor = UIColor.black
            methodImage.image = imageMethod
        }
    }
}
