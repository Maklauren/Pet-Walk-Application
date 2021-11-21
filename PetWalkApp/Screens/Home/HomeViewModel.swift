//
//  HomeViewModel.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 21.11.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class HomeViewModel {
    
    enum Route {
    }
    
    private let disposeBag = DisposeBag()
    
    lazy var route: Signal<Route> = Signal
        .merge(
            .never()
        )
    
    init() {
    }
}
