//
//  AddAPetViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 31.10.21.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class AddAPetViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "Background")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "Background")
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    
//    private var viewModel: AccountProfileViewModel!
    
    private let disposeBag = DisposeBag()
    
    var subtitle = UILabel()
    var dogPicture = UIImageView()
    
    var dogNameLabel = Stylesheet().createLabel(labelText: "Name")
    var dogNameTextField = Stylesheet().createTextField(textFieldText: "Name")
    
    var dogBreedLabel = Stylesheet().createLabel(labelText: "Breed")
    var dogBreedTextField = Stylesheet().createTextField(textFieldText: "Breed")
    
    var dogBirthdayLabel = Stylesheet().createLabel(labelText: "Birthday")
    var dogBirthdayTextField = Stylesheet().createTextField(textFieldText: "Birthday")
    
    let realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration, queue: DispatchQueue.main)
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor(named: "Background")
        
//        self.tabBarItem = UITabBarItem(title: "Profile",
//                                       image: UIImage(systemName: "camera.metering.unknown"),
//                                       selectedImage: UIImage(systemName: "camera.metering.spot"))
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Test title"
//        title = "My pets"
        navigationItem.setHidesBackButton(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(dogPicture)
        backgroundView.addSubview(stackView)
        
        backgroundView.backgroundColor = UIColor(named: "Background")
        
        [subtitle, dogPicture].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        //MARK: -Stack View
        stackView.addArrangedSubview(dogNameLabel)
        stackView.addArrangedSubview(dogNameTextField)
        stackView.addArrangedSubview(dogBreedLabel)
        stackView.addArrangedSubview(dogBreedTextField)
        stackView.addArrangedSubview(dogBirthdayLabel)
        stackView.addArrangedSubview(dogBirthdayTextField)
        
        stackView.setCustomSpacing(4, after: dogNameLabel)
        stackView.setCustomSpacing(16, after: dogNameTextField)
        stackView.setCustomSpacing(4, after: dogBreedLabel)
        stackView.setCustomSpacing(16, after: dogBreedTextField)
        stackView.setCustomSpacing(4, after: dogBirthdayLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            subtitle.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            subtitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            dogPicture.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 40),
            dogPicture.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            dogPicture.heightAnchor.constraint(equalToConstant: 120),
            dogPicture.widthAnchor.constraint(equalToConstant: 120),
            
            stackView.topAnchor.constraint(equalTo: dogPicture.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -150),
            
            dogNameTextField.heightAnchor.constraint(equalToConstant: 35),
            dogBreedTextField.heightAnchor.constraint(equalToConstant: 35),
            dogBirthdayTextField.heightAnchor.constraint(equalToConstant: 35),
            
        ])

        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.boldSystemFont(ofSize: 30)
        subtitle.text = "Add a pet"
        
        dogPicture.image = UIImage(named: "Default user")
        dogPicture.contentMode = .scaleAspectFill
        dogPicture.layer.cornerRadius = 60
        dogPicture.clipsToBounds = true
        
    }
}
