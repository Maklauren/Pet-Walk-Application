//
//  HomeCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.11.21.
//

import UIKit
import RxSwift

class HomeCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    let tabController = UITabBarController()
    
    var petsRepository = PetRepository()
    let nextCoordinator = PetAdditionCoordinator()
    
    func start() -> UIViewController {
        navigationController.setViewControllers([tabController], animated: false)
        tabController.setViewControllers([showHomeScreen(), showMyPetsScreen(), showAccountProfileScreen()], animated: false)
        return navigationController
    }
    
    func showHomeScreen() -> UIViewController {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel()
        viewController.bind(viewModel: viewModel)
        
        return viewController
    }
    
    func showMyPetsScreen() -> UIViewController {
        let viewController = MyPetsViewController()
        let viewModel = MyPetsViewModel(petsRepository: petsRepository)
        viewController.bind(viewModel: viewModel)
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController.present(self.nextCoordinator.start(), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
    
    func showAccountProfileScreen() -> UIViewController {
        let viewController = AccountProfileViewController()
        let viewModel = AccountProfileViewModel()
        viewController.bind(viewModel: viewModel)
        
        return viewController
    }
}
