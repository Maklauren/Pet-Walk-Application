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
import RAMAnimatedTabBarController
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
    
    private var realm = try! Realm()
    
    private var screenTitle = UILabel()
    private var settings = UIButton()
    private var subtitle = UILabel()
    private var userPicture = UIImageView()
    private var userName = UILabel()
    private var userCity = UILabel()
    private var userPetQuantity = UILabel()
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
        self?.viewModel.refresh()
    }))
    
    override init() {
        super.init()
        self.tabBarItem = RAMAnimatedTabBarItem(title: "", image: UIImage(systemName: "person.circle"), tag: 1)
        (self.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.refresh()
    }
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.isHidden = true
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120.0, height: 120.0)
        
        collectionView.register(PetProfileCollectionView.self, forCellWithReuseIdentifier: PetProfileCollectionView.identifier)
        collectionView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(screenTitle)
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(settings)
        backgroundView.addSubview(userPicture)
        backgroundView.addSubview(userName)
        backgroundView.addSubview(userCity)
        backgroundView.addSubview(userPetQuantity)
        backgroundView.addSubview(collectionView)
        
        [screenTitle, subtitle, settings, userPicture, userName, userCity, userPetQuantity, collectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            settings.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15),
            settings.centerYAnchor.constraint(equalTo: screenTitle.centerYAnchor),
            
            userPicture.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 19),
            userPicture.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            userPicture.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -300),
            userPicture.heightAnchor.constraint(equalToConstant: 80),
            userPicture.widthAnchor.constraint(equalToConstant: 80),
            
            userName.centerYAnchor.constraint(equalTo: userPicture.centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: userPicture.trailingAnchor, constant: 8),
            
            userCity.leadingAnchor.constraint(equalTo: userPicture.trailingAnchor, constant: 8),
            userCity.bottomAnchor.constraint(equalTo: userName.topAnchor, constant: -2),
            
            userPetQuantity.leadingAnchor.constraint(equalTo: userPicture.trailingAnchor, constant: 8),
            userPetQuantity.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 2),
            
            collectionView.topAnchor.constraint(equalTo: userPicture.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 115),
        ])
        
        scrollView.refreshControl = refreshControl
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        screenTitle.text = "Account"
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        subtitle.text = "Profile"
        
        settings.setTitleColor(UIColor(named: "Text"), for: .normal)
        settings.setTitle("settings", for: .normal)
        settings.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        userPicture.contentMode = .scaleAspectFill
        userPicture.layer.cornerRadius = 40
        userPicture.clipsToBounds = true
        userPicture.layer.borderColor = UIColor.white.cgColor
        userPicture.layer.borderWidth = 3.5
        
        userName.text = realm.objects(User.self).last?.fullName
        userName.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        
        userCity.text = realm.objects(User.self).last?.city
        userCity.textColor = UIColor(named: "Text")
        userCity.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        
        userPetQuantity.text = "\(realm.objects(Dog.self).count) pets"
        userPetQuantity.textColor = UIColor(named: "Text")
        userPetQuantity.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        
        collectionView.backgroundColor = UIColor(named: "Background")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.emptyDogArray()
    }
    
    func bind(viewModel: AccountProfileViewModel) {
        self.viewModel = viewModel
        
        viewModel.userImage
            .drive(userPicture.rx.image)
            .disposed(by: disposeBag)
        
        settings.rx.tap
            .bind(onNext: viewModel.settingsTapped)
            .disposed(by: disposeBag)
        
        viewModel.petCells
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
                .drive(collectionView.rx.items(cellIdentifier: PetProfileCollectionView.identifier, cellType: PetProfileCollectionView.self)) { index, model, cell in
                    cell.dogID = model.id
                    cell.ididid = model.id
                }
                .disposed(by: disposeBag)
    }
}

extension AccountProfileViewController: UICollectionViewDelegate {
    private func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetProfileCollectionView.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.petSelected(index: indexPath.item)
    }
}
