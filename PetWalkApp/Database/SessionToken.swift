//
//  SessionToken.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 27.11.21.
//

import Foundation
import RealmSwift

class SessionToken: Object {
    @Persisted var token: String = ""
    @Persisted var expiresAt: Date?
}

