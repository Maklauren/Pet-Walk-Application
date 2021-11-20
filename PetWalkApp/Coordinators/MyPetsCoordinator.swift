//
//  MyPetsCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 27.10.21.
//

import UIKit
import RxSwift

class MyPetsCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    let tabController = UITabBarController()
    
    var petsRepository = PetRepository()
    
    let nextCoordinator = PetAdditionCoordinator()
    
    func start() -> UIViewController {
        navigationController.setViewControllers([tabController], animated: false)
        tabController.setViewControllers([showMyPetsScreen(), showAccountProfileScreen()], animated: false)
        return navigationController
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
        
        return viewController
    }
}


