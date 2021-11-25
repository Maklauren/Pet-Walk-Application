//
//  AccountCreationCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.10.21.
//

import UIKit
import RxSwift

class AccountCreationCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.setViewControllers([showAccountCreationScreen()], animated: true)
        return navigationController
    }
    
    func showAccountCreationScreen() -> UIViewController {
        let viewController = AccountCreationViewController()
        let viewModel = AccountCreationViewModel()
        viewController.bind(viewModel: viewModel)
        
        let loginCoordinator = LoginCoordinator()
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .creationSuccess:
                    self.coordinate(to: HomeCoordinator(), animating: true)
                case .haveAnAccount:
                    self.navigationController.present(loginCoordinator.start(), animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
}
