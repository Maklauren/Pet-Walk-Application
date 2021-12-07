//
//  PetsRepository.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 19.11.21.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import Alamofire
import FirebaseAuth
import FirebaseStorage

final class PetRepository {
    
    private lazy var realm = try! Realm()
    
    private var storageRef: StorageReference!
    
    init() {
        storageRef = Storage.storage().reference()
    }
    
    func getPets() -> Single<Results<Dog>> {
        return .just(realm.objects(Dog.self))
    }
    
    func updateDogEnergy() {
        
        let dogs = realm.objects(Dog.self)
        
        for selectedDog in dogs {
            if selectedDog.dogSelectedForWalk == true {
                
                try! realm.write {
                    selectedDog.dogDayEnergyCurrent += 1
                    selectedDog.dogWeeklyEnergyCurrent += 1
                    selectedDog.dogSelectedForWalk = false
                }
            }
        }
    }
    
    func downloadAvatar(selectedDogID: String) -> Single<UIImage> {
        Single.create { observer in
            
            let avatarRef = self.storageRef.child("Pets").child(selectedDogID)
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
}

