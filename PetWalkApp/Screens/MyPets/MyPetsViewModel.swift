//
//  MyPetsViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 27.10.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class MyPetsViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Cell {
        var breed: String
        var name: String
    }
    
    private var dogArray = BehaviorRelay<[Dog]>(value: [])
    
    lazy var cells = dogArray.asDriver()
        .map {
            $0.map { (dog: Dog) -> Cell in
                Cell(breed: dog.dogBreed, name: dog.dogName)
            }
        }
    
    private let _createPetTapped = PublishRelay<Void>()
    func createPetTapped() {
        _createPetTapped.accept(())
    }
    
    private let _refresh = PublishRelay<Void>()
    func refresh() {
        _refresh.accept(())
    }
    
    lazy var route: Signal<Void> = _createPetTapped.asSignal()
    
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


