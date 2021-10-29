//
//  AccountProfileViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.10.21.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class AccountProfileViewController: BaseViewController {
    
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
    
    private var viewModel: AccountProfileViewModel!
    
    private let disposeBag = DisposeBag()
    
    var screenTitle = UILabel()
    var subtitle = UILabel()
    var userPicture = UIImageView()
    
    var userName = UILabel()
    
    let realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration, queue: DispatchQueue.main)
    
    override init() {
        super.init()
        self.tabBarItem = UITabBarItem(title: "Profile",
                                       image: UIImage(systemName: "person.circle"),
                                       selectedImage: UIImage(systemName: "person.circle.fill"))
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor(named: "Background")
        
        
        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.prefersLargeTitles = true
//        title = "Account"
//        navigationItem.setHidesBackButton(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(screenTitle)
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(userPicture)
        backgroundView.addSubview(userName)
        
        backgroundView.backgroundColor = UIColor(named: "Background")
        
        [screenTitle, subtitle, userPicture, userName].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            subtitle.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 16),
            subtitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            userPicture.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 19),
            userPicture.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            userPicture.heightAnchor.constraint(equalToConstant: 80),
            userPicture.widthAnchor.constraint(equalToConstant: 80),
            
            userName.centerYAnchor.constraint(equalTo: userPicture.centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: userPicture.trailingAnchor, constant: 8),
            
        ])
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        screenTitle.text = "Account"
        
        subtitle.textColor = UIColor.black
//        subtitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.semibold)
        subtitle.font = UIFont.boldSystemFont(ofSize: 30)
        subtitle.text = "Profile"
        
        userPicture.image = UIImage(named: "Default user")
        userPicture.contentMode = .scaleAspectFill
        userPicture.layer.cornerRadius = 40
        userPicture.clipsToBounds = true
        
        
        userName.text = realm.objects(User.self).last?.fullName
        userName.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        
    }
}
