//
//  MethodSelectionViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 30.11.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class MethodSelectionViewModel {
    
    struct petCell {
        var name: String
    }
    
    struct methodCell {
        var methodName: String
        var methodImage: UIImage
    }
    
    private let disposeBag = DisposeBag()
    
    private var dogArray = BehaviorRelay<[Dog]>(value: [])
    
    private var methodsArray = BehaviorRelay<[methodCell]>(value: [
        methodCell(methodName: "On foot", methodImage: UIImage(named: "On foot")!),
        methodCell(methodName: "On bike", methodImage: UIImage(named: "On bike")!),
        methodCell(methodName: "Other", methodImage: UIImage(named: "Other method")!)])
    
    lazy var methodsCells = methodsArray.asDriver()
    
    lazy var petCells = dogArray.asDriver()
        .map {
            $0.map { (dog: Dog) -> petCell in
                petCell(name: dog.dogName)
            }
        }
    
    lazy var route: Signal<Any> = Signal
        .merge()
    
    init(petsRepository: PetRepository) {
        petsRepository.getPets()
            .subscribe(onSuccess: {
                self.dogArray.accept(Array($0))
            })
            .disposed(by: disposeBag)
    }
}

