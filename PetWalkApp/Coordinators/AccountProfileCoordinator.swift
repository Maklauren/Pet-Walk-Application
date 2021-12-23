//
//  AccountProfileCoordinator.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 23.12.21.
//

import UIKit
import RxSwift

class AccountProfileCoordinator: CoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    let navigationController = UINavigationController(rootViewController: UIViewController())
    
    func start() -> UIViewController {
        navigationController.setViewControllers([showAccountProfileScreen()], animated: true)
        return navigationController
    }
    
    func showAccountProfileScreen() -> UIViewController {
        let viewController = AccountProfileViewController()
        let viewModel = AccountProfileViewModel()
        viewController.bind(viewModel: viewModel)
        
        let settingsCoordinator = SettingsCoordinator()
        
        let petProfileCoordinator = PetProfileCoordinator()
        
        viewModel.route
            .emit(onNext: {  [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .viewSettings:
                    self.navigationController.present(settingsCoordinator.start(), animated: true, completion: nil)
                case let .viewPetProfile(PetProfileInformation):
                    self.navigationController.present(petProfileCoordinator.start(id: PetProfileInformation.id,                             name: PetProfileInformation.name,
                                                    breed: PetProfileInformation.breed,
                                                    birthday: PetProfileInformation.birthday,
                                                    dogDayEnergyCurrent: PetProfileInformation.dogDayEnergyCurrent,
                                                    dogDayEnergy: PetProfileInformation.dogDayEnergy,
                                                    dogWeeklyEnergyCurrent: PetProfileInformation.dogWeeklyEnergyCurrent,
                                                    dogWeeklyEnergy: PetProfileInformation.dogWeeklyEnergy), animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        return viewController
    }
}
