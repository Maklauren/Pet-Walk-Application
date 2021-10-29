//
//  SessionRepository.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.10.21.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class SessionRepository {
    
    let realm = try! Realm()
    
    static let shared = SessionRepository()

    private init() {
    }

    private var state: UserState = .notLoggedIn

    func logUserIn(fullname: String, email: String) -> Single<Bool>  {
        state = .loggedIn(UserSession(fullname: fullname, email: email))
        
        let user = User()
        user.fullName = fullname
        user.email = email
        
        try! realm.write {
            realm.add(user)
        }
        
        return .just(true).delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
    }
}

