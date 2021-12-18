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
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

final class PetAdditionRepository {
    
    private let realm = try! Realm()
    
    static let shared = PetAdditionRepository()
    
    private var storageRef: StorageReference!
    
    private var databaseRef: DatabaseReference!
    
    init() {
        storageRef = Storage.storage().reference()
        
        databaseRef = Database.database(url: "https://petwalkapp-ff2e4-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    }
    
    private var state: PetState = .cantAdd
    
    func addPet(name: String, breed: String, birtday: Date, weekdayQuantity: String, weekendQuantity: String) -> Single<Bool>  {
        state = .added(PetInformation(name: name, breed: breed, birthday: birtday))
        
        let pet = Dog()
        pet.id = UserDefaults.standard.string(forKey: "dogID")!
        pet.dogName = name
        pet.dogBreed = breed
        pet.dogAge = birtday
        pet.dogDayEnergy = Int(weekdayQuantity) ?? 2
        pet.dogWeeklyEnergy = ((Int(weekdayQuantity) ?? 2) * 5) + ((Int(weekendQuantity) ?? 3) * 2)
        
        try! realm.write {
            realm.add(pet)
        }
        
        let userID = Auth.auth().currentUser?.uid
        
        databaseRef.child(userID!).child("pets").updateChildValues(["\(pet.id)": " "]) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } 
        }
        
        databaseRef.child(userID!).child("pets").child(pet.id).setValue(["dogName": pet.dogName,
                                                                    "dogBreed": pet.dogBreed,
                                                                    "dogDayEnergy": pet.dogDayEnergy,
                                                                    "dogDayEnergyCurrent": Int(0),
                                                                    "dogWeeklyEnergy": pet.dogWeeklyEnergy,
                                                                    "dogWeeklyEnergyCurrent": Int(0),
                                                                    "dogAge": "\(pet.dogAge.ISO8601Format())"
                                                                    ]) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
        
        return .just(true).delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
    }
    
    func uploadAvatar(image: UIImage) -> Single<Void> {
        Single.create { observer in
            let generateID = UUID().uuidString
            UserDefaults.standard.set(generateID, forKey: "dogID")
            
            let avatarRef = self.storageRef.child("Pets/").child(generateID)
            avatarRef.putData(image.jpegData(compressionQuality: 0.5)!, metadata: nil) { _, error in
                if let error = error {
                    observer(.failure(error))
                } else {
                    observer(.success(()))
                }
            }
            
            return Disposables.create()
        }
    }
}
