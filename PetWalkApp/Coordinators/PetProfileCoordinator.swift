//
//  PetProfileCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 8.12.21.
//

import Foundation
import RxSwift

class PetProfileCoordinator: CoordinatorType {
    func start() -> UIViewController {
        fatalError()
    }
    
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start(id: String, name: String) -> UIViewController {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([showPetProfileScreen(id: id, name: name)], animated: true)
        return navigationController
    }
    
    func showPetProfileScreen(id: String, name: String) -> UIViewController {
        let viewController = PetProfileViewController()
        let viewModel = PetProfileViewModel(petProfileInformation: PetProfileInformation(id: id, name: name))
        viewController.bind(viewModel: viewModel)
        
        return viewController
    }
}
