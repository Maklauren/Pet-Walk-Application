//
//  MethodSelectionCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 30.11.21.
//

import Foundation
import RxSwift

class MethodSelectionCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([showMethodSelectionScreen()], animated: true)
        return navigationController
    }
    
    func showMethodSelectionScreen() -> UIViewController {
        let viewController = MethodSelectionViewController()
        let viewModel = MethodSelectionViewModel(petsRepository: PetRepository())
        viewController.bind(viewModel: viewModel)
        
        let walkCoordinator = WalkCoordinator()
        
        viewModel.route
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController.present(walkCoordinator.start(), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        return viewController
    }
}
