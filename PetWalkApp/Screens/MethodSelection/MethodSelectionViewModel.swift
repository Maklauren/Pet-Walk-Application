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
    
    struct PetCell {
        var id: String
        var name: String
    }
    
    struct MethodCell {
        var methodName: String
        var methodImage: UIImage
    }
    
    private let disposeBag = DisposeBag()
    
    private var dogArray = BehaviorRelay<[Dog]>(value: [])
    
    private var methodsArray = BehaviorRelay<[MethodCell]>(value: [
        MethodCell(methodName: "On foot", methodImage: UIImage(named: "On foot")!),
        MethodCell(methodName: "On bike", methodImage: UIImage(named: "On bike")!),
        MethodCell(methodName: "Other", methodImage: UIImage(named: "Other method")!)])
    
    lazy var methodsCells = methodsArray.asDriver()
    
    lazy var petCells = dogArray.asDriver()
        .map {
            $0.map { (dog: Dog) -> PetCell in
                PetCell(id: dog.id, name: dog.dogName)
            }
        }
    
    private let _startAWalkTapped = PublishRelay<Void>()
    func startAWalkTapped() {
        _startAWalkTapped.accept(())
    }

    lazy var route: Signal<Void> = _startAWalkTapped.asSignal()
    
    init(petsRepository: PetRepository) {
        petsRepository.getPets()
            .subscribe(onSuccess: {
                self.dogArray.accept(Array($0))
            })
            .disposed(by: disposeBag)
    }
}

