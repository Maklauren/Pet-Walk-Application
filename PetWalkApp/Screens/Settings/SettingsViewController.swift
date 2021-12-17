//
//  SettingsViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 29.11.21.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RAMAnimatedTabBarController

class SettingsViewController: BaseViewController {
    
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
    
    private var viewModel: SettingsViewModel!
    
    private let disposeBag = DisposeBag()
    
    private var realm = try! Realm()
    
    var subtitle = UILabel()
    var userPicture = UIImageView()
    var selectUserPicture = UIButton()
    
    var userFullnameLabel = Stylesheet().createLabel(labelText: "Change your full name")
    lazy var userFullnameTextField = Stylesheet().createTextField(textFieldText: "\(self.realm.objects(User.self).last!.fullName)")
    
    var userCityLabel = Stylesheet().createLabel(labelText: "Change your country and city")
    lazy var userCityTextField = Stylesheet().createTextField(textFieldText: self.realm.objects(User.self).last?.city ?? "Country, City")
    
    var bottomButton = Stylesheet().createButton(buttonText: "Apply changes", buttonColor: "Background", textColor: UIColor.black)
    
    var logoutBottom = UIButton()
    
    override init() {
        super.init()
        self.tabBarItem = RAMAnimatedTabBarItem(title: "", image: UIImage(systemName: "person.circle"), tag: 1)
        (self.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
    }
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(false, animated: false)
        
        var backImageButton =  UIImage(named: "Back icon")
        backImageButton = backImageButton?.withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImageButton, style: .plain, target: self, action: #selector(onBack(_:)))
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(subtitle)
        backgroundView.addSubview(userPicture)
        backgroundView.addSubview(selectUserPicture)
        backgroundView.addSubview(stackView)
        backgroundView.addSubview(bottomButton)
        backgroundView.addSubview(logoutBottom)
        
        [subtitle, userPicture, selectUserPicture, logoutBottom].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        stackView.addArrangedSubview(userFullnameLabel)
        stackView.addArrangedSubview(userFullnameTextField)
        stackView.addArrangedSubview(userCityLabel)
        stackView.addArrangedSubview(userCityTextField)
        
        stackView.setCustomSpacing(4, after: userFullnameLabel)
        stackView.setCustomSpacing(16, after: userFullnameTextField)
        stackView.setCustomSpacing(4, after: userCityLabel)
        
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
            
            userPicture.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 20),
            userPicture.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            userPicture.heightAnchor.constraint(equalToConstant: 120),
            userPicture.widthAnchor.constraint(equalToConstant: 120),
            
            selectUserPicture.topAnchor.constraint(equalTo: userPicture.bottomAnchor, constant: 0),
            selectUserPicture.centerXAnchor.constraint(equalTo: userPicture.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: userPicture.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            
            userFullnameTextField.heightAnchor.constraint(equalToConstant: 35),
            userCityTextField.heightAnchor.constraint(equalToConstant: 35),
            
            bottomButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 163),
            bottomButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            bottomButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            bottomButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            bottomButton.heightAnchor.constraint(equalToConstant: 53),
            
            logoutBottom.topAnchor.constraint(equalTo: bottomButton.bottomAnchor, constant: 4),
            logoutBottom.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            logoutBottom.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50),
        ])
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        subtitle.text = "Settings"
        
        userPicture.image = UIImage(named: "Default user")
        userPicture.contentMode = .scaleAspectFill
        userPicture.layer.cornerRadius = 60
        userPicture.clipsToBounds = true
        
        selectUserPicture.setTitleColor(UIColor(named: "Text-2"), for: .normal)
        selectUserPicture.setTitle("Select photo", for: .normal)
        selectUserPicture.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        selectUserPicture.addTarget(self, action: #selector(addPicture(_:)), for: .touchUpInside)
        
        logoutBottom.setTitle("Log out", for: .normal)
        logoutBottom.setTitleColor(UIColor(named: "Blue"), for: .normal)
        logoutBottom.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIView.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIView.keyboardWillShowNotification, object: nil)
    }
    
    @objc func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func bind(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        viewModel.userImage
            .drive(userPicture.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.userFullnameTextField
            .drive(userFullnameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userCityTextField
            .drive(userCityTextField.rx.text)
            .disposed(by: disposeBag)
        
        userFullnameTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(userFullnameTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: realm.objects(User.self).last!.fullName)
            .bind(onNext: viewModel.userFullnameChanged)
            .disposed(by: disposeBag)
        
        userCityTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(userCityTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: "")
            .bind(onNext: viewModel.userCityChanged)
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .bind(onNext: viewModel.applySettingsTapped)
            .disposed(by: disposeBag)
        
        logoutBottom.rx.tap
            .bind(onNext: viewModel.logoutTapped)
            .disposed(by: disposeBag)
    }
    
    @objc func keyboardWillShow(_: Notification) {
        let firstResponder: UIView
        if userCityTextField.isFirstResponder {
            firstResponder = userCityTextField
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
    
    @objc func addPicture(_ sender: UIButton) {
        let cameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        let photoLibrary = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        
        let pickerController = UIImagePickerController()
        
        if cameraAvailable && photoLibrary {
            pickerController.sourceType = .camera
        } else if photoLibrary {
            pickerController.sourceType = .photoLibrary
            pickerController.allowsEditing = true
        } else {
            return
        }
        
        pickerController.delegate = self
        
        present(pickerController, animated: true, completion: nil)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageUrl = info[.editedImage] as? UIImage {
            
            userPicture.image = imageUrl
            viewModel.uploadPhoto(imageUrl)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
