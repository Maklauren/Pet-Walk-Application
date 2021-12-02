//
//  HomeViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.11.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RxOptional

final class HomeViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Cell {
        var name: String
        var breed: String
        var mood: Int
        var age: Date
    }
    
    private let _startAWalkTapped = PublishRelay<Void>()
    func startAWalkTapped() {
        _startAWalkTapped.accept(())
    }
    
    private let _refresh = PublishRelay<Void>()
    func refresh() {
        _refresh.accept(())
    }
    
    private var dogArray = BehaviorRelay<[Dog]>(value: [])
    
    lazy var cells = dogArray.asDriver()
        .map {
            $0.map { (dog: Dog) -> Cell in
                Cell(name: dog.dogName, breed: dog.dogBreed, mood: dog.dogDayEnergyCurrent, age: dog.dogAge!)
            }
        }
    
    lazy var route: Signal<Void> = _startAWalkTapped.asSignal()
    
    init(petsRepository: PetRepository) {
        petsRepository.getPets()
            .subscribe(onSuccess: {
                self.dogArray.accept(Array($0))
            })
            .disposed(by: disposeBag)
        
        _refresh
            .flatMap {
                petsRepository.getPets()
            }
            .subscribe(onNext: {
                self.dogArray.accept(Array($0))
            })
            .disposed(by: disposeBag)
    }
}
