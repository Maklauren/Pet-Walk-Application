//
//  CoordinatorType.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.10.21.
//

import UIKit

protocol CoordinatorType {
    func start() -> UIViewController

    var navigationController: UINavigationController { get }
}

extension CoordinatorType {
    var sceneDelegate: SceneDelegate? {
        return navigationController.view.window?.windowScene?.delegate as? SceneDelegate
    }

    func coordinate(to coordinator: CoordinatorType, animating: Bool) {
        func coordinate() {
            sceneDelegate?.rootCoordinator = coordinator
        }
        if animating {
            UIView.transition(with: sceneDelegate!.window!, duration: 0.2, options: [.curveEaseOut, .transitionCrossDissolve]) {
                coordinate()
            } completion: { _ in
            }
        } else {
            coordinate()
        }
    }
}
