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
    
    enum Route {
        case viewSettings
        case viewPetProfile(PetProfileInformation)
    }
    
    private let disposeBag = DisposeBag()
    
    private let _settingsTapped = PublishRelay<Void>()
    func settingsTapped() {
        _settingsTapped.accept(())
    }
    
    private let _refresh = PublishRelay<Void>()
    func refresh() {
        _refresh.accept(())
    }
    
    private let accountsRepository = AccountsRepository()
    
    private let petRepository = PetRepository()
    
    private let _petSelected = PublishRelay<Int>()
    func petSelected(index: Int) {
        _petSelected.accept(index)
    }
    
    private let _userImage = BehaviorRelay<UIImage?>(value: nil)
    lazy var userImage = _userImage.asDriver()
    
    struct PetCell {
        var id: String
    }
    
    private var dogArray = BehaviorRelay<[Dog]>(value: [])
    
    lazy var petCells = dogArray.asDriver()
        .map {
            $0.map { (dog: Dog) -> PetCell in
                PetCell(id: dog.id)
            }
        }
    
    lazy var route: Signal<Route> = Signal.merge(_settingsTapped.asSignal().map({ .viewSettings }),
                                                 
                                                 _petSelected.asSignal().withLatestFrom(dogArray.asSignal(onErrorSignalWith: .never())) { index, dogs in
            .viewPetProfile(PetProfileInformation(id: dogs[index].id, name: dogs[index].dogName, breed: dogs[index].dogBreed, birthday: dogs[index].dogAge, dogDayEnergyCurrent: dogs[index].dogDayEnergyCurrent, dogDayEnergy: dogs[index].dogDayEnergy, dogWeeklyEnergyCurrent: dogs[index].dogWeeklyEnergyCurrent, dogWeeklyEnergy: dogs[index].dogWeeklyEnergy))
    })
    
    init() {
        accountsRepository.downloadAvatar()
            .subscribe(onSuccess: {
                self._userImage.accept($0)
            })
            .disposed(by: disposeBag)
        
        petRepository.getPets()
            .subscribe(onSuccess: {
                self.dogArray.accept(Array($0))
            })
            .disposed(by: disposeBag)
        
        _refresh
            .flatMap {
                self.petRepository.getPets()
            }
            .subscribe(onNext: {
                self.dogArray.accept(Array($0))
            })
            .disposed(by: disposeBag)
    }
}

