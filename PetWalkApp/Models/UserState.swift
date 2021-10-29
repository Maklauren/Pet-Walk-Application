//
//  UserState.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.10.21.
//

import Foundation

enum UserState {
    case guest
    case notLoggedIn
    case loggedIn(UserSession)
}
