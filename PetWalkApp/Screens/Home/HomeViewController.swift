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
import RxDataSources
import RxOptional
import RAMAnimatedTabBarController
import Charts

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
    
    private var screenTitle = UILabel()
    private var subtitle = UILabel()
    private var statsTitle = UILabel()
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let tableView = UITableView()
    
    private var startAWalkButton = Stylesheet().createButton(buttonText: "Start a walk", buttonColor: "Blue button", textColor: UIColor.white)
    
    private lazy var refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
        self?.viewModel.refresh()
    }))
    
    let realm = try! Realm()
    
    override init() {
        super.init()
        self.tabBarItem = RAMAnimatedTabBarItem(title: "", image: UIImage(systemName: "house"), tag: 1)
        (self.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        viewModel.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 388.0, height: 96.0)
        
        collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: PetCollectionViewCell.identifier)
        collectionView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(screenTitle)
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(collectionView)
        backgroundView.addSubview(startAWalkButton)
        backgroundView.addSubview(statsTitle)
        backgroundView.addSubview(tableView)
        
        scrollView.refreshControl = refreshControl
        
        [screenTitle, subtitle, collectionView, statsTitle, tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            collectionView.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 115),
            
            statsTitle.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            statsTitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            tableView.topAnchor.constraint(equalTo: statsTitle.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 288),
            
            startAWalkButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 100),
            startAWalkButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            startAWalkButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            startAWalkButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50),
            startAWalkButton.heightAnchor.constraint(equalToConstant: 53),
        ])
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        screenTitle.text = "Home"
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        subtitle.text = "Dashboard"
        
        collectionView.backgroundColor = UIColor(named: "Background")
        collectionView.isPagingEnabled = true
        
        statsTitle.textColor = UIColor.black
        statsTitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        statsTitle.text = "Stats"
        
        tableView.register(PetStatsTableViewCell.self, forCellReuseIdentifier: PetStatsTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.emptyDogArray()
    }
    
    func bind(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        viewModel.petCells
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
                .drive(collectionView.rx.items(cellIdentifier: PetCollectionViewCell.identifier, cellType: PetCollectionViewCell.self)) { index, model, cell in
                    cell.dogID = model.id
                    cell.nameText = model.name
                    cell.breedText = model.breed
                    cell.moodText = String(model.mood)
                    cell.ageText = model.age
                }
                .disposed(by: disposeBag)
        
        viewModel.statArray
            .drive(tableView.rx.items(cellIdentifier: PetStatsTableViewCell.identifier, cellType: PetStatsTableViewCell.self)) { index, model, cell in
                cell.statText = model.statName
            }
            .disposed(by: disposeBag)
        
        startAWalkButton.rx.tap
            .bind(onNext: viewModel.startAWalkTapped)
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegate {    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! PetCollectionViewCell
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        item.layer.borderColor = UIColor(named: "Blue button")?.cgColor
        
        let dogs = realm.objects(Dog.self)
        let dogsFilter = dogs.filter({ $0.dogName == item.nameText }).first
        
        let itemStatistic = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PetStatsTableViewCell
        itemStatistic.energyCurrentInt = dogsFilter!.dogDayEnergyCurrent
        
        var difference = dogsFilter!.dogDayEnergy - dogsFilter!.dogDayEnergyCurrent
        if difference < 0 {
            difference = 0
        }
        itemStatistic.energyTotalInt = difference
        
        let percent = Int((Double(dogsFilter!.dogDayEnergyCurrent) / Double(dogsFilter!.dogDayEnergy)) * 100)
        itemStatistic.detailedInfo = "\(percent)% accomplished"
        tableView.reloadData()
        
        let itemStatisticSecond = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! PetStatsTableViewCell
        itemStatisticSecond.energyCurrentInt = dogsFilter!.dogDayEnergy
        difference = dogsFilter!.dogWeeklyEnergy - dogsFilter!.dogWeeklyEnergyCurrent
        if difference < 0 {
            difference = 0
        }
        itemStatisticSecond.energyTotalInt = difference
        
        let countWalksLeft = dogsFilter!.dogWeeklyEnergy - dogsFilter!.dogWeeklyEnergyCurrent
        itemStatisticSecond.detailedInfo = "\(countWalksLeft) walks left"
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
