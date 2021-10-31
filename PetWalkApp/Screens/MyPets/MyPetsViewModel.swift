//
//  MyPetsViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 27.10.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class MyPetsViewModel {

    private let disposeBag = DisposeBag()

    private let _createPetTapped = PublishRelay<Void>()
    func createPetTapped() {
        _createPetTapped.accept(())
    }
    
    lazy var route: Signal<Void> = _createPetTapped.asSignal()

    init() {
    }

}
