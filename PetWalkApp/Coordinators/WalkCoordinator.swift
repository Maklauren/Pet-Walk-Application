//
//  WalkCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 1.12.21.
//

import Foundation
import RxSwift

class WalkCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([showWalkScreen()], animated: true)
        return navigationController
    }
    
    func showWalkScreen() -> UIViewController {
        let viewController = WalkViewController()
        let viewModel = WalkViewModel()
        viewController.bind(viewModel: viewModel)
        
        return viewController
    }
}
