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
    
    struct PetCell {
        var id: String
        var name: String
        var breed: String
        var mood: Int
        var age: Date
    }
    
    struct StatsCell {
        var statName: String
    }
    
    private let _startAWalkTapped = PublishRelay<Void>()
    func startAWalkTapped() {
        _startAWalkTapped.accept(())
    }
    
    private let _refresh = PublishRelay<Void>()
    func refresh() {
        _refresh.accept(())
    }
    
    private let _refreshStatistic = PublishRelay<Void>()
    func refreshStatistic() {
        _refreshStatistic.accept(())
    }
    
    private var dogArray = BehaviorRelay<[Dog]>(value: [])
    
    lazy var petCells = dogArray.asDriver()
        .map {
            $0.map { (dog: Dog) -> PetCell in
                PetCell(id: dog.id, name: dog.dogName, breed: dog.dogBreed, mood: dog.dogDayEnergyCurrent, age: dog.dogAge)
            }
        }
    
    private var statsArray = BehaviorRelay<[StatsCell]>(value: [StatsCell(statName: "Today's plan"), StatsCell(statName: "Weekly objectives")])
    
    lazy var statArray = statsArray.asDriver()
    
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
