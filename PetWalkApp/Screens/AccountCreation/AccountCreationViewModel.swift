//
//  AccountCreationViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.10.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RealmSwift

final class AccountCreationViewModel {
    
    enum Route {
        case creationSuccess
        case haveAnAccount
    }
    
    private let disposeBag = DisposeBag()
    
    private let _userPictureChanged = PublishRelay<UIImageView>()
    func userPictureChanged(_ image: UIImageView) {
        _userPictureChanged.accept(image)
    }
    
    private let _fullnameFieldChanged = PublishRelay<String>()
    func fullnameFieldChanged(_ text: String) {
        _fullnameFieldChanged.accept(text)
    }
    
    private let _emailFieldChanged = PublishRelay<String>()
    func emailFieldChanged(_ text: String) {
        _emailFieldChanged.accept(text)
    }
    
    private let _passwordFieldChanged = PublishRelay<String>()
    func passwordFieldChanged(_ text: String) {
        _passwordFieldChanged.accept(text)
    }
    
    private let _createAccountTapped = PublishRelay<Void>()
    func createAccountTapped() {
        _createAccountTapped.accept(())
    }
    
    private let _haveAnAccountTapped = PublishRelay<Void>()
    func haveAnAccountTapped() {
        _haveAnAccountTapped.accept(())
    }
    
    lazy var userPicture = _userPictureChanged
    
    lazy var fullnameTextField = _fullnameFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var emailTextField = _emailFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var passwordTextField = _passwordFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var route: Signal<Route> = Signal
        .merge(
            _createAccountTapped.asObservable()
                .withLatestFrom(Observable.combineLatest(fullnameTextField.asObservable(), emailTextField.asObservable(), passwordTextField.asObservable()))
                .flatMapLatest { fullname, email, password in
                    SessionRepository.shared.createUser(fullname: fullname, email: email, password: password)
                        .debug("Registration Result")
                        .asSignal(onErrorSignalWith: .never())
                }
                .debug("SESSION LOGIN")
                .map { _ in .creationSuccess}
                .asSignal(onErrorSignalWith: .never()),
            _haveAnAccountTapped.asSignal()
                .map { _ in .haveAnAccount }
        )
    
    init() {
        _createAccountTapped.asSignal().emit(onNext: { print("NEXT VC") }).disposed(by: disposeBag)
    }
}

