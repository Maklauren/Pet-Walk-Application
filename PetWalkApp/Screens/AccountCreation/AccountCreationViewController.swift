//
//  AccountCreationViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 6.10.21.
//

import UIKit
import RxSwift
import RxCocoa

class AccountCreationViewController: BaseViewController {
    
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
    
    private var viewModel: AccountCreationViewModel!
    
    private let disposeBag = DisposeBag()
    
    var subtitle = UILabel()
    var logoPicture = UIImageView()
    
    var fullNameLabel = Stylesheet().createLabel(labelText: "Required field")
    var fullNameTextField = Stylesheet().createTextField(textFieldText: "Full name")
    
    var emailLabel = Stylesheet().createLabel(labelText: "Required field")
    var emailTextField = Stylesheet().createTextField(textFieldText: "Email adress")
    
    var passwordLabel = Stylesheet().createLabel(labelText: "Required field")
    var passwordTextField = Stylesheet().createTextField(textFieldText: "Password")
    
    var bottomButton = Stylesheet().createButton(buttonText: "Create my account", buttonColor: "Background", textColor: UIColor.black)
    var loginButton = UIButton()
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "New user"
        navigationItem.setHidesBackButton(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(logoPicture)
        backgroundView.addSubview(stackView)
        backgroundView.addSubview(bottomButton)
        backgroundView.addSubview(loginButton)
        
        [subtitle, logoPicture, loginButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        stackView.addArrangedSubview(fullNameLabel)
        stackView.addArrangedSubview(fullNameTextField)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordLabel)
        stackView.addArrangedSubview(passwordTextField)
        
        stackView.setCustomSpacing(4, after: fullNameLabel)
        stackView.setCustomSpacing(16, after: fullNameTextField)
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
            
            subtitle.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            subtitle.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            
            logoPicture.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 40),
            logoPicture.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            logoPicture.heightAnchor.constraint(equalToConstant: 120),
            logoPicture.widthAnchor.constraint(equalToConstant: 120),
            
            stackView.topAnchor.constraint(equalTo: logoPicture.bottomAnchor, constant: 22),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            
            fullNameTextField.heightAnchor.constraint(equalToConstant: 35),
            emailTextField.heightAnchor.constraint(equalToConstant: 35),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),
            
            bottomButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 163),
            bottomButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            bottomButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            bottomButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            bottomButton.heightAnchor.constraint(equalToConstant: 53),
            
            loginButton.topAnchor.constraint(equalTo: bottomButton.bottomAnchor, constant: 4),
            loginButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50),
        ])
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.boldSystemFont(ofSize: 25)
        subtitle.text = "Account creation"
        
        logoPicture.image = UIImage(named: "Illustration")
        logoPicture.contentMode = .scaleAspectFill
        logoPicture.clipsToBounds = true
        
        loginButton.setTitle("You have an account ? Login", for: .normal)
        loginButton.setTitleColor(UIColor(named: "Blue"), for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        fullNameTextField.textContentType = .username
        fullNameTextField.autocapitalizationType = .none
        fullNameTextField.autocorrectionType = .no
        fullNameTextField.textContentType = .nickname
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.textContentType = .emailAddress
        
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = .password
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIView.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIView.keyboardWillShowNotification, object: nil)
    }
    
    func bind(viewModel: AccountCreationViewModel) {
        self.viewModel = viewModel
        
        viewModel.fullnameTextField
            .drive(fullNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emailTextField
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordTextField
            .drive(passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userPicture
            .bind(to: logoPicture.rx.image)
            .disposed(by: disposeBag)
        
        fullNameTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(fullNameTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: "")
            .bind(onNext: viewModel.fullnameFieldChanged)
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
        
        bottomButton.rx.tap
            .bind(onNext: viewModel.createAccountTapped)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(onNext: viewModel.haveAnAccountTapped)
            .disposed(by: disposeBag)
    }
    
    @objc func keyboardWillShow(_: Notification) {
        let firstResponder: UIView
        if fullNameTextField.isFirstResponder {
            firstResponder = fullNameTextField
        } else if emailTextField.isFirstResponder {
            firstResponder = emailTextField
        } else if passwordTextField.isFirstResponder {
            firstResponder = passwordTextField
        } else {
            return
        }
        scrollView.scrollRectToVisible(firstResponder.frame, animated: true)
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIView.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: view.frame.height - keyboardFrame.origin.y, right: 0.0)
    }
}


