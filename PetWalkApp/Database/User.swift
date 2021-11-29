//
//  User.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 26.10.21.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var fullName: String = ""
    @Persisted var email: String = ""
    @Persisted var city: String = ""
    
    @Persisted var pets: List<Dog>
}
