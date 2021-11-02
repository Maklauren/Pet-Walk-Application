//
//  Stylesheet.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 5.10.21.
//

import UIKit

class Stylesheet {
    
    //MARK: -Main Bottom Button
    func createButton(buttonText: String, buttonColor: String, textColor: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = UIColor(named: buttonColor)
        
        button.setTitleColor(textColor, for: .normal)
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 12
        
        button.layer.borderWidth = 3.5
        button.layer.borderColor = UIColor.white.cgColor
        
        button.layer.cornerRadius = 26.5
        
        return button
    }
    
    //MARK: -Label
    func createLabel(labelText: String) -> UILabel {
        let label = UILabel()
        
        label.textColor = UIColor(named: "Text")
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = labelText
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    //MARK: -TextField
    func createTextField(textFieldText: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor.black
        textField.attributedPlaceholder = NSAttributedString(string: textFieldText, attributes: [NSAttributedString.Key.foregroundColor: UIColor(ciColor: .black)])
        textField.font = UIFont.systemFont(ofSize: 20)
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 5))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }
}
