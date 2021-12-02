//
//  PetsRepository.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 19.11.21.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import Alamofire

final class PetRepository {
    
    private lazy var realm = try! Realm()
    
    func getPets() -> Single<Results<Dog>> {
        return .just(realm.objects(Dog.self))
    }
    
    func updateDogEnergy() {
        
        let dogs = realm.objects(Dog.self)
        
        for selectedDog in dogs {
            if selectedDog.dogSelectedForWalk == true {
                
                try! realm.write {
                    selectedDog.dogDayEnergyCurrent += 1
                    selectedDog.dogWeeklyEnergyCurrent += 1
                    selectedDog.dogSelectedForWalk = false
                }
            }
        }
    }
}

