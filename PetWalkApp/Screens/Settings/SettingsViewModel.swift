//
//  SettingsViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 29.11.21.
//

import Foundation
import RealmSwift
import RxSwift
import RxRelay
import RxCocoa

final class SettingsViewModel {
    
    enum Route {
        case creationSuccess
        case logout
    }
    
    private let disposeBag = DisposeBag()
    
    private let accountsRepository: AccountsRepository
    
    private var realm = try! Realm()
    
    func uploadPhoto(_ image: UIImage) {
        accountsRepository.uploadAvatar(image: image)
            .subscribe(onSuccess: { print("Photo uploaded") })
            .disposed(by: disposeBag)
    }
    
    private let _userImage = BehaviorRelay<UIImage?>(value: nil)
    lazy var userImage = _userImage.asDriver()
    
    private let _userFullnameChanged = PublishRelay<String>()
    func userFullnameChanged(_ text: String) {
        _userFullnameChanged.accept(text)
    }
    
    private let _userCityChanged = PublishRelay<String>()
    func userCityChanged(_ text: String) {
        _userCityChanged.accept(text)
    }
    
    private let _applySettingsTapped = PublishRelay<Void>()
    func applySettingsTapped() {
        _applySettingsTapped.accept(())
    }
    
    private let _logoutTapped = PublishRelay<Void>()
    func logoutTapped() {
        _logoutTapped.accept(())
    }
    
    lazy var userFullnameTextField = _userFullnameChanged.asDriver(onErrorJustReturn: "").startWith(realm.objects(User.self).last!.fullName)
    
    lazy var userCityTextField = _userCityChanged.asDriver(onErrorJustReturn: "").startWith(realm.objects(User.self).last?.city ?? "")
    
    lazy var route: Signal<Route> = Signal
        .merge(
            _applySettingsTapped.asObservable()
                .withLatestFrom(Observable.combineLatest(userFullnameTextField.asObservable(), userCityTextField.asObservable()))
                .flatMapLatest { fullname, city in
                    AccountsRepository.shared.settingsChanges(fullname: fullname, city: city).asObservable()
                }
                .debug("SETTING SESSION")
                .filter { $0 == true }
                .map { _ in .creationSuccess }
                .asSignal(onErrorSignalWith: .never()),
            
            _logoutTapped.asSignal()
                .map { SessionRepository.shared.logout() }
                .map { _ in .logout }
        )
    
    init() {
        self.accountsRepository = AccountsRepository()
        accountsRepository.downloadAvatar()
            .subscribe(onSuccess: {
                self._userImage.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
