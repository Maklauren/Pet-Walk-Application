//
//  SettingsCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 29.11.21.
//

import Foundation
import RxSwift

class SettingsCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([showSettingsScreen()], animated: true)
        return navigationController
    }
    
    func showSettingsScreen() -> UIViewController {
        let viewController = SettingsViewController()
        let viewModel = SettingsViewModel()
        viewController.bind(viewModel: viewModel)
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .creationSuccess:
                    self.navigationController.dismiss(animated: true, completion: nil)
                case .logout:
                    self.coordinate(to: StartScreenCoordinator(), animating: true)
                }
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
}
