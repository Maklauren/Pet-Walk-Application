//
//  LoginViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 25.11.21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
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
    
    private var viewModel: LoginViewModel!
    
    private let disposeBag = DisposeBag()
    
    var emailLabel = Stylesheet().createLabel(labelText: "Required field")
    var emailTextField = Stylesheet().createTextField(textFieldText: "Email adress")
    
    var passwordLabel = Stylesheet().createLabel(labelText: "Required field")
    var passwordTextField = Stylesheet().createTextField(textFieldText: "Password")
    
    var loginButton = Stylesheet().createButton(buttonText: "LOG IN", buttonColor: "Background", textColor: UIColor.black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(false, animated: false)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Authentication"
        
        var backImageButton =  UIImage(named: "Back icon")
        backImageButton = backImageButton?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImageButton, style: .plain, target: self, action: #selector(onBack(_:)))
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        
        backgroundView.addSubview(stackView)
        backgroundView.addSubview(loginButton)
        
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordLabel)
        stackView.addArrangedSubview(passwordTextField)
        
        stackView.setCustomSpacing(4, after: emailLabel)
        stackView.setCustomSpacing(16, after: emailTextField)
        stackView.setCustomSpacing(4, after: passwordLabel)
        
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
            
            stackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 35),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),
            
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 500),
            loginButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            loginButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            loginButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50),
            loginButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 53),
        ])
    }
    
    @objc func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func bind(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        viewModel.emailTextField
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordTextField
            .drive(passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(emailTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: "")
            .bind(onNext: viewModel.emailFieldChanged)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(passwordTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: "")
            .bind(onNext: viewModel.passwordFieldChanged)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(onNext: viewModel.loginTapped)
            .disposed(by: disposeBag)
    }
}

