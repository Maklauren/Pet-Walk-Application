//
//  PetAdditionRepository.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 6.11.21.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class PetAdditionRepository {
    
    let realm = try! Realm()
    
    static let shared = PetAdditionRepository()
    
    init() {
    }
    
    private var state: PetState = .cantAdd

    func addPet(name: String, breed: String, birtday: Date, weekdayQuantity: String, weekendQuantity: String) -> Single<Bool>  {
        state = .added(PetInformation(name: name, breed: breed, birthday: birtday))
        
        let pet = Dog()
        pet.dogName = name
        pet.dogBreed = breed
        pet.dogAge = birtday
        pet.dogDayEnergy = Int(weekdayQuantity) ?? 2
        pet.dogWeeklyEnergy = ((Int(weekdayQuantity) ?? 2) * 5) + ((Int(weekendQuantity) ?? 3) * 2)
    
        try! realm.write {
            realm.add(pet)
        }
        
        return .just(true).delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
    }
}


