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
    
//    var dogNameLabelText: Observable<String>
    
    lazy var dogNameLabelText = BehaviorSubject<String>(value: "")
    
    private let _dogImage = BehaviorRelay<UIImage?>(value: nil)
    lazy var dogImage = _dogImage.asDriver()
    
    init(petProfileInformation: PetProfileInformation) {
        dogNameLabelText.onNext(petProfileInformation.name)
        
        print(petProfileInformation.name)
        petRepository.downloadAvatar(selectedDogID: petProfileInformation.id)
            .subscribe(onSuccess: {
                self._dogImage.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
