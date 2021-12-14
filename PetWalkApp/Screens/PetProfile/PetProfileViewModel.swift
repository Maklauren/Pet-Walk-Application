//
//  PetProfileViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 7.12.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class PetProfileViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let petRepository = PetRepository()
    
    lazy var route: Signal<Void> = Signal.merge()
    
    lazy var dogName = BehaviorSubject<String>(value: "")
    lazy var dogBreed = BehaviorSubject<String>(value: "")
    lazy var dogDayEnergyCurrent = BehaviorSubject<Int>(value: 0)
    lazy var dogDayEnergyTotal = BehaviorSubject<Int>(value: 0)
    lazy var dogWeeklyEnergyCurrent = BehaviorSubject<Int>(value: 0)
    lazy var dogWeeklyEnergyTotal = BehaviorSubject<Int>(value: 0)
    
    private let _dogImage = BehaviorRelay<UIImage?>(value: nil)
    lazy var dogImage = _dogImage.asDriver()
    
    init(petProfileInformation: PetProfileInformation) {
        dogName.onNext(petProfileInformation.name)
        dogBreed.onNext(petProfileInformation.breed)
        dogDayEnergyCurrent.onNext(petProfileInformation.dogDayEnergyCurrent)
        dogDayEnergyTotal.onNext(petProfileInformation.dogDayEnergy)
        dogWeeklyEnergyCurrent.onNext(petProfileInformation.dogWeeklyEnergyCurrent)
        dogWeeklyEnergyTotal.onNext(petProfileInformation.dogWeeklyEnergy)
        
        petRepository.downloadAvatar(selectedDogID: petProfileInformation.id)
            .subscribe(onSuccess: {
                self._dogImage.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
