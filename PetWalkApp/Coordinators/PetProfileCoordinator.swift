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
    
    func start(id: String, name: String, breed: String, birthday: Date, dogDayEnergyCurrent: Int, dogDayEnergy: Int, dogWeeklyEnergyCurrent: Int, dogWeeklyEnergy: Int) -> UIViewController {
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([showPetProfileScreen(id: id, name: name, breed: breed, birthday: birthday, dogDayEnergyCurrent: dogDayEnergyCurrent, dogDayEnergy: dogDayEnergy, dogWeeklyEnergyCurrent: dogWeeklyEnergyCurrent, dogWeeklyEnergy: dogWeeklyEnergy)], animated: true)
        return navigationController
    }
    
    func showPetProfileScreen(id: String, name: String, breed: String, birthday: Date, dogDayEnergyCurrent: Int, dogDayEnergy: Int, dogWeeklyEnergyCurrent: Int, dogWeeklyEnergy: Int) -> UIViewController {
        let viewController = PetProfileViewController()
        let viewModel = PetProfileViewModel(petProfileInformation: PetProfileInformation(id: id, name: name, breed: breed, birthday: birthday, dogDayEnergyCurrent: dogDayEnergyCurrent, dogDayEnergy: dogDayEnergy, dogWeeklyEnergyCurrent: dogWeeklyEnergyCurrent, dogWeeklyEnergy: dogWeeklyEnergy))
        viewController.bind(viewModel: viewModel)
        
        return viewController
    }
}
