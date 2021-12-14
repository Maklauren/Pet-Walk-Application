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
    
    private var screenTitle = UILabel()
    private var subtitle = UILabel()
    
    private var dogPicture = UIImageView()
    private var dogName = UILabel()
    private var dogBreed = UILabel()
    private var dayEnergyCurrent = UILabel()
    private var dayEnergyTotal = UILabel()
    private var weeklyEnergyCurrent = UILabel()
    private var weeklyEnergyTotal = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
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
        backgroundView.addSubview(dayEnergyCurrent)
        backgroundView.addSubview(dayEnergyTotal)
        backgroundView.addSubview(weeklyEnergyCurrent)
        backgroundView.addSubview(weeklyEnergyTotal)
        
        [screenTitle, subtitle, dogPicture, dogName, dogBreed, dayEnergyCurrent, dayEnergyTotal, weeklyEnergyCurrent, weeklyEnergyTotal].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            screenTitle.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            screenTitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            subtitle.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 0),
            subtitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            dogPicture.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 19),
            dogPicture.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            dogPicture.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -350),
            dogPicture.heightAnchor.constraint(equalToConstant: 100),
            dogPicture.widthAnchor.constraint(equalToConstant: 100),
            
            dogName.centerYAnchor.constraint(equalTo: dogPicture.centerYAnchor),
            dogName.leadingAnchor.constraint(equalTo: dogPicture.trailingAnchor, constant: 8),
            
            dogBreed.leadingAnchor.constraint(equalTo: dogPicture.trailingAnchor, constant: 8),
            dogBreed.bottomAnchor.constraint(equalTo: dogName.topAnchor, constant: -2),
            
            dayEnergyTotal.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            dayEnergyTotal.topAnchor.constraint(equalTo: dogPicture.bottomAnchor, constant: 19),
            
            dayEnergyCurrent.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            dayEnergyCurrent.topAnchor.constraint(equalTo: dayEnergyTotal.bottomAnchor, constant: 5),
            
            weeklyEnergyTotal.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            weeklyEnergyTotal.topAnchor.constraint(equalTo: dayEnergyCurrent.bottomAnchor, constant: 5),
            
            weeklyEnergyCurrent.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            weeklyEnergyCurrent.topAnchor.constraint(equalTo: weeklyEnergyTotal.bottomAnchor, constant: 5)
        ])
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        screenTitle.text = "Pet"
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        subtitle.text = "Profile"
        
        dogPicture.image = UIImage(named: "Default user")
        dogPicture.contentMode = .scaleAspectFill
        dogPicture.layer.cornerRadius = 50
        dogPicture.clipsToBounds = true
        dogPicture.layer.borderColor = UIColor.white.cgColor
        dogPicture.layer.borderWidth = 3.5
        
        dogName.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
        
        dogBreed.textColor = UIColor(named: "Text")
        dogBreed.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        
        [dayEnergyTotal, dayEnergyCurrent, weeklyEnergyTotal, weeklyEnergyCurrent].forEach { $0.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium) }
    }
    
    @objc func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func bind(viewModel: PetProfileViewModel) {
        self.viewModel = viewModel
        
        viewModel.dogName
            .bind(to: dogName.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogBreed
            .bind(to: dogBreed.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogDayEnergyTotal
            .map({ "Number of walks per day: \(String($0))" })
            .bind(to: dayEnergyTotal.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogDayEnergyCurrent
            .map({ "Current number of walks per day: \(String($0))" })
            .bind(to: dayEnergyCurrent.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogWeeklyEnergyTotal
            .map({ "Number of walks per week: \(String($0))" })
            .bind(to: weeklyEnergyTotal.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogWeeklyEnergyCurrent
            .map({ "Current number of walks per week: \(String($0))" })
            .bind(to: weeklyEnergyCurrent.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogImage
            .drive(dogPicture.rx.image)
            .disposed(by: disposeBag)
    }
}
