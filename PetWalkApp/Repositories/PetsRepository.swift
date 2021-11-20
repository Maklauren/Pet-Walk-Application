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

final class PetRepository {
    
    private lazy var realm = try! Realm()

    func getPets() -> Single<Results<Dog>> {
        return .just(realm.objects(Dog.self))
    }
}
