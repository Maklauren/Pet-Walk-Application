//
//  LoginViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 25.11.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RealmSwift

final class LoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let _emailFieldChanged = PublishRelay<String>()
    func emailFieldChanged(_ text: String) {
        _emailFieldChanged.accept(text)
    }
    
    private let _passwordFieldChanged = PublishRelay<String>()
    func passwordFieldChanged(_ text: String) {
        _passwordFieldChanged.accept(text)
    }
    
    private let _loginTapped = PublishRelay<Void>()
    func loginTapped() {
        _loginTapped.accept(())
    }
    
    lazy var emailTextField = _emailFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var passwordTextField = _passwordFieldChanged.asDriver(onErrorJustReturn: "").startWith("")
    
    lazy var route: Signal<Void> = _loginTapped.asSignal()
    
    init() {
        _loginTapped.asSignal().emit(onNext: { print("NEXT VC") }).disposed(by: disposeBag)
    }
}

