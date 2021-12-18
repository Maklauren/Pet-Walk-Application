//
//  MethodSelectionViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 30.11.21.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class MethodSelectionViewController: BaseViewController {
    
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
    
    private var viewModel: MethodSelectionViewModel!
    
    private let disposeBag = DisposeBag()
    
    private let realm = try! Realm()
    
    private var petSelectionLabel = UILabel()
    private var methodSelectionLabel = UILabel()
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let tableView = UITableView()
    
    private var startAWalkButton = Stylesheet().createButton(buttonText: "Start a walk", buttonColor: "Blue button", textColor: UIColor.white)
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(false, animated: false)
        
        var backImageButton =  UIImage(named: "Back icon")
        backImageButton = backImageButton?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImageButton, style: .plain, target: self, action: #selector(onBack(_:)))
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110.0, height: 130.0)
        
        collectionView.register(PetSelectionViewCell.self, forCellWithReuseIdentifier: PetSelectionViewCell.identifier)
        collectionView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(petSelectionLabel)
        backgroundView.addSubview(collectionView)
        backgroundView.addSubview(methodSelectionLabel)
        backgroundView.addSubview(tableView)
        backgroundView.addSubview(startAWalkButton)
        
        [petSelectionLabel, collectionView, methodSelectionLabel, tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            petSelectionLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            petSelectionLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            collectionView.topAnchor.constraint(equalTo: petSelectionLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 140),
            
            methodSelectionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            methodSelectionLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            tableView.topAnchor.constraint(equalTo: methodSelectionLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 288),
            
            startAWalkButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 100),
            startAWalkButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            startAWalkButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            startAWalkButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50),
            startAWalkButton.heightAnchor.constraint(equalToConstant: 53),
        ])
        
        petSelectionLabel.textColor = UIColor.black
        petSelectionLabel.font = UIFont.boldSystemFont(ofSize: 30)
        petSelectionLabel.text = "Pet selection"
        
        collectionView.backgroundColor = UIColor(named: "Background")
        
        methodSelectionLabel.textColor = UIColor.black
        methodSelectionLabel.font = UIFont.boldSystemFont(ofSize: 30)
        methodSelectionLabel.text = "Method selection"
        
        tableView.register(MethodSelectionViewCell.self, forCellReuseIdentifier: MethodSelectionViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.delegate = self
    }
    
    @objc func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func bind(viewModel: MethodSelectionViewModel) {
        self.viewModel = viewModel
        
        viewModel.petCells
            .drive(collectionView.rx.items(cellIdentifier: PetSelectionViewCell.identifier, cellType: PetSelectionViewCell.self)) { index, model, cell in
                cell.dogID = model.id
                cell.nameText = model.name
            }
            .disposed(by: disposeBag)
        
        viewModel.methodsCells
            .drive(tableView.rx.items(cellIdentifier: MethodSelectionViewCell.identifier, cellType: MethodSelectionViewCell.self)) { index, model, cell in
                cell.method = model.methodName
                cell.imageMethod = model.methodImage
            }
            .disposed(by: disposeBag)
        
        startAWalkButton.rx.tap
            .bind(onNext: viewModel.startAWalkTapped)
            .disposed(by: disposeBag)
    }
}

extension MethodSelectionViewController: UICollectionViewDelegate {
    private func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetSelectionViewCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath) as! PetSelectionViewCell
        
        if item.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            item.layer.borderColor = UIColor.white.cgColor
            
            try! realm.write {
                let dogs = realm.objects(Dog.self)
                let dogsFilter = dogs.filter({ $0.dogName == item.nameText }).first
                
                dogsFilter?.dogSelectedForWalk = false
            }
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            item.layer.borderColor = UIColor(named: "Blue")?.cgColor
            
            try! realm.write {
                let dogs = realm.objects(Dog.self)
                let dogsFilter = dogs.filter({ $0.dogName == item.nameText }).first
                
                dogsFilter?.dogSelectedForWalk = true
            }
            return true
        }
        
        return false
    }
}

extension MethodSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
