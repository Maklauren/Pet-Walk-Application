//
//  LoginCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 25.11.21.
//

import Foundation
import RxSwift

class LoginCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([showLoginScreen()], animated: false)
        return navigationController
    }
    
    func showLoginScreen() -> UIViewController {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel()
        viewController.bind(viewModel: viewModel)
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinate(to: HomeCoordinator(), animating: false)
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
}
