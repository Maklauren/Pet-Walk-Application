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
        navigationController.setViewControllers([showLoginScreen()], animated: true)
        return navigationController
    }
    
    func showLoginScreen() -> UIViewController {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel()
        viewController.bind(viewModel: viewModel)
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .loginSuccess:
                    self.coordinate(to: HomeCoordinator(), animating: true)
                }
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
}
