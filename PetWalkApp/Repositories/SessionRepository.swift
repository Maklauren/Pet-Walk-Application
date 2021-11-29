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
import FirebaseAuth

final class SessionRepository {
    static let shared = SessionRepository()
    
    let realm = try! Realm()
    
    enum SessionError: Error {
        case noActiveSession
        case expiredSession
        case noError
    }
    
    private init() {
    }
    
    private var state: UserState = .notLoggedIn
    
    func logUserIn(email: String, password: String) -> Single<Void> {
        Single.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { auth, error in
                if let auth = auth {
                    observer(.success(()))
                    print(auth)
                    return
                }
                observer(.failure(error ?? SessionError.noError))
            }
            return Disposables.create()
        }
    }
    
    func createUser(fullname: String, email: String, password: String) -> Single<Void>  {
        Single.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { auth, error in
                if let auth = auth {
                    observer(.success(()))
                    print(auth)
                    
                    let user = User()
                    user.fullName = fullname
                    user.email = email
                    user.city = ""
                    
                    try! self.realm.write {
                        self.realm.add(user)
                    }
                    return
                }
                observer(.failure(error ?? SessionError.noError))
            }
            return Disposables.create()
        }
    }
    
    func getActiveSession() -> Single<SessionToken> {
        if let user = Auth.auth().currentUser {
            return Single.create { observer in
                user.getIDToken { token, error in
                    if let token = token {
                        let session = SessionToken()
                        session.token = token
                        observer(.success(session))
                    }
                    observer(.failure(error ?? SessionError.noError))
                }
                
                return Disposables.create()
            }
        }
        return .error(SessionError.noActiveSession)
    }
}

