//
//  Observable+replaceNil.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.10.21.
//

import Foundation
import RxSwift

extension ObservableType {
    func replaceNil<Result>(with value: Result) -> Observable<Result> where Element == Result? {
        return self.map { $0 ?? value }
    }
}
