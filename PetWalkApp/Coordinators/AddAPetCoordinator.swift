//
//  AddAPetCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 31.10.21.
//

import Foundation
import RxSwift

class AddAPetCoordinator: CoordinatorType {

    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.setViewControllers([showAddAPetScreen()], animated: false)
        return navigationController
    }

    func showAddAPetScreen() -> UIViewController {
        let viewController = AddAPetViewController()
        let viewModel = AddAPetViewModel()
        viewController.bind(viewModel: viewModel)
        
        return viewController
    }
}
