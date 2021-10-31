//
//  MyPetsViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 27.10.21.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class MyPetsViewController: BaseViewController {
    
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
    
    private var viewModel: MyPetsViewModel!
    
    private let disposeBag = DisposeBag()
    
    var screenTitle = UILabel()
    var subtitle = UILabel()
    
    var addButton = UIButton()
    
    let realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration, queue: DispatchQueue.main)
    
    override init() {
        super.init()
        self.tabBarItem = UITabBarItem(title: "Profile",
                                       image: UIImage(systemName: "camera.metering.unknown"),
                                       selectedImage: UIImage(systemName: "camera.metering.spot"))
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor(named: "Background")
        
        navigationController?.navigationBar.isHidden = true
        //        navigationController?.navigationBar.prefersLargeTitles = true
        //        title = "My pets"
        //        navigationItem.setHidesBackButton(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(screenTitle)
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(addButton)
        
        backgroundView.backgroundColor = UIColor(named: "Background")
        
        [screenTitle, subtitle, addButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            addButton.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 500),
            addButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -100),
            addButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 200),
            addButton.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        //        screenTitle.font = UIFont.boldSystemFont(ofSize: 30)
        screenTitle.text = "My pets"
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.boldSystemFont(ofSize: 30)
        subtitle.text = "Dogs"
        
        addButton.setImage(UIImage(named: "Add button"), for: .normal)
        //        addButton.image = UIImage(named: "Add button")
        //        addButton.contentMode = .scaleAspectFill
        //        //        userPicture.layer.cornerRadius = 60
        //        addButton.clipsToBounds = false
    }
    
    func bind(viewModel: MyPetsViewModel) {
        self.viewModel = viewModel
        
        addButton.rx.tap
            .bind(onNext: viewModel.createPetTapped)
            .disposed(by: disposeBag)
    }
}
