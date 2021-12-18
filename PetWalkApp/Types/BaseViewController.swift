//
//  BaseViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 20.10.21.
//

import UIKit

class BaseViewController: UIViewController {

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
}
