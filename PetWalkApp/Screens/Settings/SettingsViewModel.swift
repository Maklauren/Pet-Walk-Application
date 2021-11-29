//
//  SettingsViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 29.11.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class SettingsViewModel {
    
    enum Route {
        case creationSuccess
    }
    
    private let disposeBag = DisposeBag()
    
    private let accountsRepository: AccountsRepository
    
    func uploadPhoto(_ image: UIImage) {
        accountsRepository.uploadAvatar(image: image)
            .subscribe(onSuccess: { print("Photo uploaded") })
            .disposed(by: disposeBag)
    }
    
    private let _userImage = BehaviorRelay<UIImage?>(value: nil)
    lazy var userImage = _userImage.asDriver()
    
    private let _userCityChanged = PublishRelay<String>()
    func userCityChanged(_ text: String) {
        _userCityChanged.accept(text)
    }
    
    private let _weekdayQuantityChanged = PublishRelay<String>()
    func weekdayQuantityChanged(_ string: String) {
        _weekdayQuantityChanged.accept(string)
    }
    
    private let _weekendQuantityChanged = PublishRelay<String>()
    func weekendQuantityChanged(_ string: String) {
        _weekendQuantityChanged.accept(string)
    }
    
    private let _applySettingsTapped = PublishRelay<Void>()
    func applySettingsTapped() {
        _applySettingsTapped.accept(())
    }
    
    lazy var userCityTextField = _userCityChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var weekdayQuantityTextField = _weekdayQuantityChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var weekendQuantityTextField = _weekendQuantityChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var route: Signal<Route> = Signal
        .merge(
            _applySettingsTapped.asObservable()
                .withLatestFrom(Observable.combineLatest(userCityTextField.asObservable(), weekdayQuantityTextField.asObservable(), weekendQuantityTextField.asObservable()))
                .flatMapLatest { city, week, weekend in
                    AccountsRepository.shared.settingsChanges(city: city, weekdayQuantity: week, weekendQuantity: weekend).asObservable()
                }
                .debug("SETTING SESSION")
                .filter { $0 == true }
                .map { _ in .creationSuccess }
                .asSignal(onErrorSignalWith: .never())
        )
    
    init() {
        self.accountsRepository = AccountsRepository()
        accountsRepository.downloadAvatar()
            .subscribe(onSuccess: {
                self._userImage.accept($0)
            })
            .disposed(by: disposeBag)
        
        _applySettingsTapped.asSignal().emit(onNext: { print("APPLY SETTINGS") }).disposed(by: disposeBag)
    }
}



