//
//  AccountProfileViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.10.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class AccountProfileViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let _settingsTapped = PublishRelay<Void>()
    func settingsTapped() {
        _settingsTapped.accept(())
    }
    
    private let accountsRepository: AccountsRepository
    
    lazy var route: Signal<Void> = _settingsTapped.asSignal()
    
    private let _userImage = BehaviorRelay<UIImage?>(value: nil)
    lazy var userImage = _userImage.asDriver()
    
    init() {
        self.accountsRepository = AccountsRepository()
        accountsRepository.downloadAvatar()
            .subscribe(onSuccess: {
                self._userImage.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
}

