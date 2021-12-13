//
//  PetProfileViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 7.12.21.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class PetProfileViewController: BaseViewController {
    
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
    
    private var viewModel: PetProfileViewModel!
    
    private let disposeBag = DisposeBag()
    
    let realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration, queue: DispatchQueue.main)
    
    var screenTitle = UILabel()
    var subtitle = UILabel()
    var dogPicture = UIImageView()
    var dogName = UILabel()
    var dogBreed = UILabel()
    var dogAge = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func loadView() {
        super.loadView()
        
        navigationItem.setHidesBackButton(false, animated: false)
        
        var backImageButton =  UIImage(named: "Back icon")
        backImageButton = backImageButton?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImageButton, style: .plain, target: self, action: #selector(onBack(_:)))
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(screenTitle)
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(dogPicture)
        backgroundView.addSubview(dogName)
        backgroundView.addSubview(dogBreed)
        backgroundView.addSubview(dogAge)
        
        [screenTitle, subtitle, dogPicture, dogName, dogBreed, dogAge].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            screenTitle.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 50),
            screenTitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            subtitle.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 0),
            subtitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            dogPicture.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 19),
            dogPicture.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            dogPicture.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -300),
            dogPicture.heightAnchor.constraint(equalToConstant: 80),
            dogPicture.widthAnchor.constraint(equalToConstant: 80),
            
            dogName.centerYAnchor.constraint(equalTo: dogPicture.centerYAnchor),
            dogName.leadingAnchor.constraint(equalTo: dogPicture.trailingAnchor, constant: 8),
            
            dogBreed.leadingAnchor.constraint(equalTo: dogPicture.trailingAnchor, constant: 8),
            dogBreed.bottomAnchor.constraint(equalTo: dogName.topAnchor, constant: -2),
            
            dogAge.leadingAnchor.constraint(equalTo: dogPicture.trailingAnchor, constant: 8),
            dogAge.topAnchor.constraint(equalTo: dogName.bottomAnchor, constant: 2),
        ])
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        screenTitle.text = "Pet"
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        subtitle.text = "Profile"
        
        dogPicture.image = UIImage(named: "Default user")
        dogPicture.contentMode = .scaleAspectFill
        dogPicture.layer.cornerRadius = 40
        dogPicture.clipsToBounds = true
        dogPicture.layer.borderColor = UIColor.white.cgColor
        dogPicture.layer.borderWidth = 3.5
        
//        dogName.text = viewModel.petProfile.name
        dogName.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        
        
        dogBreed.text = realm.objects(User.self).last?.city
        dogBreed.textColor = UIColor(named: "Text")
        dogBreed.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        
//        dogAge.text = "\(realm.objects(Dog.self).count) pets"
//        dogAge.textColor = UIColor(named: "Text")
//        dogAge.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
    }
    
    @objc func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func bind(viewModel: PetProfileViewModel) {
        self.viewModel = viewModel
        
        viewModel.dogNameLabelText
            .debug()
            .bind(to: dogName.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogImage
            .drive(dogPicture.rx.image)
            .disposed(by: disposeBag)
    }
}
