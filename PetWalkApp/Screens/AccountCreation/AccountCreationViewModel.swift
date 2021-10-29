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
    }
    
    private let disposeBag = DisposeBag()
    
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
    
    
    lazy var fullnameTextField = _fullnameFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var emailTextField = _emailFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var passwordTextField = _passwordFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var route: Signal<Route> = Signal
        .merge(
            _createAccountTapped.asObservable()
                .withLatestFrom(Observable.combineLatest(fullnameTextField.asObservable(), emailTextField.asObservable()))
                .flatMapLatest { fullname, email in
                    SessionRepository.shared.logUserIn(fullname: fullname, email: email).asObservable()
                }
                .debug("SESSION LOGIN")
                .filter { $0 == true }
                .map { _ in .creationSuccess }
                .asSignal(onErrorSignalWith: .never())
        )
    
    
    init() {
        _createAccountTapped.asSignal().emit(onNext: { print("NEXT VC") }).disposed(by: disposeBag)
        
//        _createAccountTapped.asObservable()
//            .withLatestFrom(Observable.combineLatest(fullnameTextField.asObservable(), emailTextField.asObservable()))
//            .flatMapLatest { fullname, email in
//                SessionRepository.shared.logUserIn(fullname: fullname, email: email)
//            }
//            .debug("SESSION LOGIN")
//            .subscribe(onNext: { _ in })
//            .disposed(by: disposeBag)
        
    }
    
}

