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
    
    enum Route {
    }
    
    private let disposeBag = DisposeBag()
    
    struct Cell {
        var name: String
    }
    
    lazy var route: Signal<Route> = Signal
        .merge(
            .never()
        )
    
    private var dogArray = BehaviorRelay<[Dog]>(value: [])
    
    lazy var cells = dogArray.asDriver()
        .map {
            $0.map { (dog: Dog) -> Cell in
                Cell(name: dog.dogName)
            }
        }
    
    init(petsRepository: PetRepository) {
        petsRepository.getPets()
            .subscribe(onSuccess: {
                self.dogArray.accept(Array($0))
            })
            .disposed(by: disposeBag)
    }
}
