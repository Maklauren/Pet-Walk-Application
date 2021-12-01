//
//  Pet.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 26.10.21.
//

import Foundation
import RealmSwift

class Dog: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var dogName: String = ""
    @Persisted var dogAge: Date? = nil
    @Persisted var dogBreed: String = ""
    @Persisted var dogDayEnergyCurrent: Int = 0
    @Persisted var dogDayEnergy: Int = 2
    @Persisted var dogWalkLenghts: Double = 0
    @Persisted var dogWeeklyEnergyCurrent: Int = 0
    @Persisted var dogWeeklyEnergy: Int = 16
    @Persisted var dogSelectedForWalk: Bool = false
    
    @Persisted var owner: User?
}
