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
import RAMAnimatedTabBarController

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
    
    private lazy var refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
        self?.viewModel.refresh()
    }))
    
    private var screenTitle = UILabel()
    private var subtitle = UILabel()
    private var addButton = UIButton()
    
    private let tableView = UITableView()
    
    override init() {
        super.init()
        self.tabBarItem = RAMAnimatedTabBarItem(title: "", image: UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))?.withTintColor(.black, renderingMode: .alwaysOriginal), tag: 1)
        (self.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.refresh()
    }
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(screenTitle)
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(tableView)
        backgroundView.addSubview(addButton)
        
        scrollView.refreshControl = refreshControl
        
        [screenTitle, subtitle, tableView, addButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            tableView.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 480),
            
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            addButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -100),
            addButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 200),
            addButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        screenTitle.text = "My pets"
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        subtitle.text = "Dogs"
        
        tableView.register(PetTableViewCell.self, forCellReuseIdentifier: PetTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.delegate = self
        
        addButton.setImage(UIImage(named: "Add button"), for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.emptyDogArray()
    }
    
    func bind(viewModel: MyPetsViewModel) {
        self.viewModel = viewModel
        
        viewModel.cells
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .drive(tableView.rx.items(cellIdentifier: PetTableViewCell.identifier, cellType: PetTableViewCell.self)) { index, model, cell in
                cell.dogID = model.id
                cell.breedText = model.breed
                cell.nameText = model.name
                cell.ageText = model.date
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(onNext: viewModel.createPetTapped)
            .disposed(by: disposeBag)
    }
}

extension MyPetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
