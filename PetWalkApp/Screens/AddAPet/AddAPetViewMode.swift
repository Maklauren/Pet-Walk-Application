//
//  AddAPetViewMode.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 31.10.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class AddAPetViewModel {

    private let disposeBag = DisposeBag()

    private let _dogNameFieldChanged = PublishRelay<String>()
    func dogNameFieldChanged(_ text: String) {
        _dogNameFieldChanged.accept(text)
    }
    
    private let _dogBreedFieldChanged = PublishRelay<String>()
    func dogBreedFieldChanged(_ text: String) {
        _dogBreedFieldChanged.accept(text)
    }
    
    private let _dogBirthdayFieldChanged = PublishRelay<String>()
    func dogBirthdayFieldChanged(_ text: String) {
        _dogBirthdayFieldChanged.accept(text)
    }

    private let _createPetTapped = PublishRelay<Void>()
    func createPetTapped() {
        _createPetTapped.accept(())
    }
    
    lazy var dogNameTextField = _dogNameFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var dogBreedTextField = _dogBreedFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var dogBirthdayTextField = _dogBirthdayFieldChanged.asDriver(onErrorJustReturn: "").startWith("")

    init() {
        _createPetTapped.asSignal().emit(onNext: { print("PET ADDED") }).disposed(by: disposeBag)
    }

}
