//
//  StartScreenCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.10.21.
//

import UIKit
import RxSwift

class StartScreenCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.setViewControllers([showStartScreen()], animated: false)
        return navigationController
    }
    
    func showStartScreen() -> UIViewController {
        let viewController = StartScreenViewController()
        let viewModel = StartScreenViewModel()
        viewController.bind(viewModel: viewModel)
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                    self.coordinate(to: AccountCreationCoordinator(), animating: false)
            })
            .disposed(by: disposeBag)
        
        
        
        //        viewModel.route
        //            .emit(onNext: { [weak self] in
        //                guard let self = self else { return }
        //                switch $0 {
        //                case .loginSuccess:
        //                    self.coordinate(to: HomeCoordinator(), animating: true)
        //                }
        //            })
        //            .disposed(by: disposeBag)
        return viewController
    }
}
