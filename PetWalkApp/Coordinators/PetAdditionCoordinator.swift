//
//  AddAPetCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 31.10.21.
//

import Foundation
import RxSwift

class PetAdditionCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([showAddAPetScreen()], animated: false)
        return navigationController
    }
    
    func showAddAPetScreen() -> UIViewController {
        let viewController = PetAdditionViewController()
        let viewModel = PetAdditionViewModel()
        viewController.bind(viewModel: viewModel)
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .creationSuccess:
                    self.navigationController.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
}
