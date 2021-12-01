//
//  WalkViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 1.12.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class WalkViewModel {
    
    private let disposeBag = DisposeBag()
    
    lazy var route: Signal<Void> = Signal
        .merge(
        )
    
    init() {
    }
}
