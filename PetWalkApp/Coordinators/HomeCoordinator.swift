//
//  HomeCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.11.21.
//

import UIKit
import RxSwift
import RAMAnimatedTabBarController

class HomeCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    let tabController = RAMAnimatedTabBarController()
    
    var petsRepository = PetRepository()
    
    func start() -> UIViewController {
        navigationController.setViewControllers([tabController], animated: true)
        tabController.setViewControllers([showHomeScreen(), showMyPetsScreen(), showAccountProfileScreen()], animated: true)
        return navigationController
    }
    
    func showHomeScreen() -> UIViewController {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(petsRepository: petsRepository)
        viewController.bind(viewModel: viewModel)
        
        let methodSelectionCoordinator = MethodSelectionCoordinator()
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController.present(methodSelectionCoordinator.start(), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
    
    func showMyPetsScreen() -> UIViewController {
        let viewController = MyPetsViewController()
        let viewModel = MyPetsViewModel(petsRepository: petsRepository)
        viewController.bind(viewModel: viewModel)
        
        let petAdditionCoordinator = PetAdditionCoordinator()
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController.present(petAdditionCoordinator.start(), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
    
    func showAccountProfileScreen() -> UIViewController {
        let viewController = AccountProfileViewController()
        let viewModel = AccountProfileViewModel()
        viewController.bind(viewModel: viewModel)
        
        let settingsCoordinator = SettingsCoordinator()
        
        let petProfileCoordinator = PetProfileCoordinator()
        
        viewModel.route
            .emit(onNext: {  [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .viewSettings:
                    self.navigationController.present(settingsCoordinator.start(), animated: true, completion: nil)
                case let .viewPetProfile(PetProfileInformation):
                    self.navigationController.present(petProfileCoordinator.start(id: PetProfileInformation.id, name: PetProfileInformation.name), animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
}

