//
//  AccountsRepository.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 29.11.21.
//

import Foundation
import RxSwift
import RealmSwift
import FirebaseAuth
import FirebaseStorage


final class AccountsRepository {
    static let shared = AccountsRepository()
    
    private lazy var realm = try! Realm()
    
    private var storageRef: StorageReference!
    
    init() {
        storageRef = Storage.storage().reference()
    }
    
    func uploadAvatar(image: UIImage) -> Single<Void> {
        Single.create { observer in
            
            let avatarRef = self.storageRef.child("Avatars").child(Auth.auth().currentUser!.uid)
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
    
    func downloadAvatar() -> Single<UIImage> {
        Single.create { observer in

            let avatarRef = self.storageRef.child("Avatars").child(Auth.auth().currentUser!.uid)
            avatarRef.getData(maxSize: 5_000_000) { data, error in
                if let error = error {
                    observer(.failure(error))
                } else {
                    observer(.success(data!))
                }
            }

            return Disposables.create()
        }
        .map { UIImage(data: $0)! }
    }
    
    func settingsChanges(city: String, weekdayQuantity: String, weekendQuantity: String) -> Single<Bool>  {
        
        let user = User()
        user.city = city
        
        let pet = Dog()
        pet.dogDayEnergy = Int(weekdayQuantity) ?? 2
        pet.dogWeeklyEnergy = (Int(weekdayQuantity) ?? 2 * 5) + (Int(weekendQuantity) ?? 3 * 2)
    
        try! realm.write {
            realm.add(pet)
        }
        
        return .just(true).delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
    }
}
