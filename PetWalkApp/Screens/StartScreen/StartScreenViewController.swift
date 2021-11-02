//
//  ViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 5.10.21.
//

import UIKit
import RxSwift
import RxCocoa

class StartScreenViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "Background")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "Background")
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()

    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    
    private var viewModel: StartScreenViewModel!

    private let disposeBag = DisposeBag()
    
    var logoImage = UIImageView()
    var illustrationImage = UIImageView()
    var appInformation = UILabel()
    
    var bottomButton = Stylesheet().createButton(buttonText: "Let's start", buttonColor: "Background", textColor: UIColor.black)
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        
        backgroundView.backgroundColor = UIColor(named: "Background")
        
        stackView.addArrangedSubview(logoImage)
        stackView.addArrangedSubview(illustrationImage)
        stackView.addArrangedSubview(appInformation)
        stackView.addArrangedSubview(bottomButton)
        
        stackView.setCustomSpacing(3, after: logoImage)
        stackView.setCustomSpacing(8, after: illustrationImage)
        stackView.setCustomSpacing(32, after: appInformation)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 72),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 29),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -29),
            stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -83),
            
            bottomButton.heightAnchor.constraint(equalToConstant: 53),
        ])
        
        logoImage.image = UIImage(named: "Logo")
        illustrationImage.image = UIImage(named: "Illustration")
        
        logoImage.contentMode = .scaleAspectFill
        illustrationImage.contentMode = .scaleAspectFill
        
        appInformation.textColor = UIColor(named: "Text")
        appInformation.numberOfLines = 10
        appInformation.font = UIFont.systemFont(ofSize: 18)

        let attributedString = NSMutableAttributedString(string: "The Pet Walk app is designed for taking care of your pet. Fixe objectives based on their needs. See their progresses and share them with the community.")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .left
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attributedString.length))
        appInformation.attributedText = attributedString
    }
    
    func bind(viewModel: StartScreenViewModel) {
        self.viewModel = viewModel
        
        bottomButton.rx.tap
            .bind(onNext: viewModel.buttonTapped)
            .disposed(by: disposeBag)
    }
}

