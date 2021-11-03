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
    @Persisted var dogAge: Date
    @Persisted var dogBreed: String = ""
    @Persisted var dogDayEnergy: Double
    @Persisted var dogWalkLenghts: Double
    @Persisted var dogWeeklyEnergy: Double
}
