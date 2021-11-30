//
//  MethodSelectionViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 30.11.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class MethodSelectionViewModel {
    
    private let disposeBag = DisposeBag()
    
    lazy var route: Signal<Any> = Signal
        .merge()
    
    init() {
    }
}

