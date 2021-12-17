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
import FirebaseDatabase

final class SessionRepository {
    static let shared = SessionRepository()
    
    let realm = try! Realm()
    
    private var databaseRef: DatabaseReference!
    
    enum SessionError: Error {
        case noActiveSession
        case expiredSession
        case noError
    }
    
    private init() {
        databaseRef = Database.database(url: "https://petwalkapp-ff2e4-default-rtdb.europe-west1.firebasedatabase.app/").reference()
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
    
    func getInformationForExistingPerson() {
        
        try! self.realm.write {
            self.realm.deleteAll()
        }
        
        let userID = Auth.auth().currentUser?.uid
        let userEmail = Auth.auth().currentUser?.email
        
        databaseRef.child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            
            let userFullname = value?["fullname"] as? String ?? ""
            let userCity = value?["city"] as? String ?? ""
            
            let user = User()
            user.id = userID!
            user.fullName = userFullname
            user.email = userEmail!
            user.city = userCity
            
            try! self.realm.write {
                self.realm.add(user)
            }
            
        }) { error in
            print(error.localizedDescription)
        }
        
        databaseRef.child(userID!).child("pets").observeSingleEvent(of: .value, with: { [self] snapshot in
            
            let value = (snapshot.value as? NSDictionary) as? [String:Any]
            
            
            guard let value = value else {
                return
            }
            
            for dogKey in value.keys {
                let dog = Dog()
                guard let dogDict = value[dogKey] as? [String: Any],
                      let dogName = dogDict["dogName"] as? String,
                      let dogBreed = dogDict["dogBreed"] as? String,
                      let dogDayEnergy = dogDict["dogDayEnergy"] as? Int,
                      let dogDayEnergyCurrent = dogDict["dogDayEnergyCurrent"] as? Int,
                      let dogWeeklyEnergy = dogDict["dogWeeklyEnergy"] as? Int,
                      let dogWeeklyEnergyCurrent = dogDict["dogWeeklyEnergyCurrent"] as? Int,
                      let dogAge = dogDict["dogAge"] as? String
                else {
                    return
                }
                
                dog.id = dogKey
                dog.dogName = dogName
                dog.dogBreed = dogBreed
                dog.dogDayEnergy = dogDayEnergy
                dog.dogDayEnergyCurrent = dogDayEnergyCurrent
                dog.dogWeeklyEnergy = dogWeeklyEnergy
                dog.dogWeeklyEnergyCurrent = dogWeeklyEnergyCurrent
                dog.dogSelectedForWalk = false
                dog.owner = realm.objects(User.self).first
                
                let dateFormatter = ISO8601DateFormatter()
                let correctDate = dateFormatter.date(from: dogAge)
                dog.dogAge = correctDate ?? NSDate() as Date
                
                try! self.realm.write {
                    self.realm.add(dog)
                }
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func logout() {
        
        try! self.realm.write {
            self.realm.deleteAll()
        }
        
        let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
    }
}
