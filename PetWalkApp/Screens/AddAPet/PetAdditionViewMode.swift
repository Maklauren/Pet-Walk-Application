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

final class PetAdditionViewModel {
    
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
    
    private let _weekdayQuantityChanged = PublishRelay<String>()
    func weekdayQuantityChanged(_ string: String) {
        _weekdayQuantityChanged.accept(string)
    }
    
    private let _weekendQuantityChanged = PublishRelay<String>()
    func weekendQuantityChanged(_ string: String) {
        _weekendQuantityChanged.accept(string)
    }
    
    private let _createPetTapped = PublishRelay<Void>()
    func createPetTapped() {
        _createPetTapped.accept(())
    }
    
    lazy var dogNameTextField = _dogNameFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var dogBreedTextField = _dogBreedFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var weekdayQuantityTextField = _weekdayQuantityChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var weekendQuantityTextField = _weekendQuantityChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var dogBirthdayTextField = _dogBirthdayFieldChanged
    
    lazy var route: Signal<Route> = Signal
        .merge(
            _createPetTapped.asObservable()
                .withLatestFrom(Observable.combineLatest(dogNameTextField.asObservable(), dogBreedTextField.asObservable(), dogBirthdayTextField.asObservable(), weekdayQuantityTextField.asObservable(), weekendQuantityTextField.asObservable()))
                .flatMapLatest { name, breed, birthday, week, weekend in
                    PetAdditionRepository.shared.addPet(name: name, breed: breed, birtday: birthday, weekdayQuantity: week, weekendQuantity: weekend).asObservable()
                }
                .debug("PET SESSION")
                .filter { $0 == true }
                .map { _ in .creationSuccess }
                .asSignal(onErrorSignalWith: .never())
        )
    
    init() {
        _createPetTapped.asSignal().emit(onNext: { print("PET ADDED") }).disposed(by: disposeBag)
    }
}
