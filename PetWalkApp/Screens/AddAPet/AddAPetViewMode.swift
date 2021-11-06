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
    
    enum Route {
        case creationSuccess
    }
    
    private let disposeBag = DisposeBag()
    
    private let _dogNameFieldChanged = PublishRelay<String>()
    func dogNameFieldChanged(_ text: String) {
        _dogNameFieldChanged.accept(text)
    }
    
    private let _dogBreedFieldChanged = PublishRelay<String>()
    func dogBreedFieldChanged(_ text: String) {
        _dogBreedFieldChanged.accept(text)
    }
    
    private let _dogBirthdayFieldChanged = PublishRelay<Date>()
    func dogBirthdayFieldChanged(_ date: Date) {
        _dogBirthdayFieldChanged.accept(date)
    }
    
    private let _createPetTapped = PublishRelay<Void>()
    func createPetTapped() {
        _createPetTapped.accept(())
    }
    
    private let _leftNavigationBarItemTapped = PublishRelay<Void>()
    func leftNavigationBarItemTapped() {
        _leftNavigationBarItemTapped.accept(())
    }
    
    lazy var dogNameTextField = _dogNameFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var dogBreedTextField = _dogBreedFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var dogBirthdayTextField = _dogBirthdayFieldChanged
    
    lazy var route: Signal<Route> = Signal
        .merge(
            _createPetTapped.asObservable()
                .withLatestFrom(Observable.combineLatest(dogNameTextField.asObservable(), dogBreedTextField.asObservable(), dogBirthdayTextField.asObservable()))
                .flatMapLatest { name, breed, birthday in
                    PetAdditionRepository.shared.addPet(name: name, breed: breed, birtday: birthday).asObservable()
                }
                .debug("PET SESSION")
                .filter { $0 == true }
                .map { _ in .creationSuccess }
                .asSignal(onErrorSignalWith: .never())
        )
    
    init() {
        _createPetTapped.asSignal().emit(onNext: { print("PET ADDED") }).disposed(by: disposeBag)
        _leftNavigationBarItemTapped.asSignal().emit(onNext: { print("BACK") }).disposed(by: disposeBag)
    }
    
}
