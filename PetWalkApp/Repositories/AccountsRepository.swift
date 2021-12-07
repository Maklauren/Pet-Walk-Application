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
import FirebaseDatabase

final class AccountsRepository {
    static let shared = AccountsRepository()
    
    private lazy var realm = try! Realm()
    
    private var storageRef: StorageReference!
    
    private var databaseRef: DatabaseReference!
    
    init() {
        storageRef = Storage.storage().reference()
        
        databaseRef = Database.database(url: "https://petwalkapp-ff2e4-default-rtdb.europe-west1.firebasedatabase.app/").reference()
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
    
    func settingsChanges(fullname: String, city: String) -> Single<Bool>  {
        
        try! realm.write {
            let user = realm.objects(User.self).last
            user?.fullName = fullname
            user?.city = city
        }
        
        let userID = Auth.auth().currentUser?.uid
        
        databaseRef.child(userID!).updateChildValues(["fullname": fullname,
                                                      "city": city,
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
}
