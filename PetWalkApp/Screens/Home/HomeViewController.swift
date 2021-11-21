//
//  HomeViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.11.21.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class HomeViewController: BaseViewController {

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
    
    private var viewModel: HomeViewModel!
    
    private let disposeBag = DisposeBag()
    
    var screenTitle = UILabel()
    var subtitle = UILabel()
    
    override init() {
        super.init()
        self.tabBarItem = UITabBarItem(title: "",
                                       image: UIImage(systemName: "house"),
                                       selectedImage: UIImage(systemName: "house.fill"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(screenTitle)
        backgroundView.addSubview(subtitle)
        
        backgroundView.backgroundColor = UIColor(named: "Background")
        
        [screenTitle, subtitle].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
        ])
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        screenTitle.text = "Home"
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        subtitle.text = "Dashboard"
    }
    
    func bind(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}
