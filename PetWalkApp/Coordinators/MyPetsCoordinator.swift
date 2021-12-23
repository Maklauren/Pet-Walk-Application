//
//  MyPetsCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 23.12.21.
//

import UIKit
import RxSwift

class MyPetsCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    var petsRepository = PetRepository()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.setViewControllers([showMyPetsScreen()], animated: true)
        return navigationController
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
}
