//
//  WalkViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 1.12.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class WalkViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let petsRepository = PetRepository()
    
    private let _endTheWalkButtonTapped = PublishRelay<Void>()
    func endTheWalkButtonTapped() {
        _endTheWalkButtonTapped.accept(())
    }
    
    lazy var route: Signal<Void> = _endTheWalkButtonTapped.asSignal().do(onNext: petsRepository.updateDogEnergy)
    
    init() {
    }
}
