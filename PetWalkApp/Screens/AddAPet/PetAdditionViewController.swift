//
//  AddAPetViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 31.10.21.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class PetAdditionViewController: BaseViewController {
    
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
    
    private var viewModel: PetAdditionViewModel!
    
    private let disposeBag = DisposeBag()
    
    let realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration, queue: DispatchQueue.main)
    
    var subtitle = UILabel()
    var dogPicture = UIButton()
    
    var dogNameLabel = Stylesheet().createLabel(labelText: "Name")
    var dogNameTextField = Stylesheet().createTextField(textFieldText: "Name")
    
    var dogBreedLabel = Stylesheet().createLabel(labelText: "Breed")
    var dogBreedTextField = Stylesheet().createTextField(textFieldText: "Breed")
    
    var dogBirthdayLabel = Stylesheet().createLabel(labelText: "Birthday")
    
    var question = UILabel()
    
    var weekdayLabel = Stylesheet().createLabel(labelText: "Weekday")
    var weekdayTextField = Stylesheet().createTextField(textFieldText: "Just a number")
    
    var weekendLabel = Stylesheet().createLabel(labelText: "Weekend")
    var weekendTextField = Stylesheet().createTextField(textFieldText: "Just a number")
    
    var dogBirthdayDatePicker = UIDatePicker()
    
    var bottomButton = Stylesheet().createButton(buttonText: "Add a pet", buttonColor: "Blue button", textColor: UIColor.white)
    
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
        backgroundView.addSubview(dogPicture)
        backgroundView.addSubview(stackView)
        backgroundView.addSubview(bottomButton)
        backgroundView.addSubview(dogBirthdayDatePicker)
        
        [subtitle, dogPicture, dogBirthdayDatePicker].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        //MARK: -Stack View
        stackView.addArrangedSubview(dogNameLabel)
        stackView.addArrangedSubview(dogNameTextField)
        stackView.addArrangedSubview(dogBreedLabel)
        stackView.addArrangedSubview(dogBreedTextField)
        stackView.addArrangedSubview(dogBirthdayLabel)
        stackView.addArrangedSubview(dogBirthdayDatePicker)
        stackView.addArrangedSubview(question)
        stackView.addArrangedSubview(weekdayLabel)
        stackView.addArrangedSubview(weekdayTextField)
        stackView.addArrangedSubview(weekendLabel)
        stackView.addArrangedSubview(weekendTextField)
        
        stackView.setCustomSpacing(4, after: dogNameLabel)
        stackView.setCustomSpacing(16, after: dogNameTextField)
        stackView.setCustomSpacing(4, after: dogBreedLabel)
        stackView.setCustomSpacing(16, after: dogBreedTextField)
        stackView.setCustomSpacing(4, after: dogBirthdayLabel)
        stackView.setCustomSpacing(16, after: dogBirthdayDatePicker)
        stackView.setCustomSpacing(4, after: question)
        stackView.setCustomSpacing(4, after: weekdayLabel)
        stackView.setCustomSpacing(16, after: weekdayTextField)
        stackView.setCustomSpacing(4, after: weekendLabel)
        
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
            
            dogPicture.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 40),
            dogPicture.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            dogPicture.heightAnchor.constraint(equalToConstant: 120),
            dogPicture.widthAnchor.constraint(equalToConstant: 120),
            
            stackView.topAnchor.constraint(equalTo: dogPicture.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            
            dogNameTextField.heightAnchor.constraint(equalToConstant: 35),
            dogBreedTextField.heightAnchor.constraint(equalToConstant: 35),
            dogBirthdayDatePicker.heightAnchor.constraint(equalToConstant: 35),
            weekdayTextField.heightAnchor.constraint(equalToConstant: 35),
            weekendTextField.heightAnchor.constraint(equalToConstant: 35),
            
            dogBirthdayDatePicker.centerXAnchor.constraint(equalTo: dogBirthdayLabel.centerXAnchor),
            dogBirthdayDatePicker.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -275),
            
            bottomButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            bottomButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 22),
            bottomButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -22),
            bottomButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -50),
            bottomButton.heightAnchor.constraint(equalToConstant: 53),
        ])
        
        subtitle.textColor = UIColor.black
        subtitle.font = UIFont.boldSystemFont(ofSize: 30)
        subtitle.text = "Add a pet"
        
        dogPicture.setImage(UIImage(named: "Default user"), for: .normal)
        dogPicture.contentMode = .scaleAspectFill
        dogPicture.layer.cornerRadius = 60
        dogPicture.clipsToBounds = true
        dogPicture.addTarget(self, action: #selector(addPicture(_:)), for: .touchUpInside)
        
        dogBirthdayDatePicker.datePickerMode = .date
        dogBirthdayDatePicker.tintColor = UIColor.white
        
        question.text = "How many times a day you walk your dog?"
        question.textColor = UIColor(named: "Text-2")
        question.font = UIFont.systemFont(ofSize: 18)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIView.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIView.keyboardWillShowNotification, object: nil)
    }
    
    @objc func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func bind(viewModel: PetAdditionViewModel) {
        self.viewModel = viewModel
        
        viewModel.dogNameTextField
            .drive(dogNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogBreedTextField
            .drive(dogBreedTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dogBirthdayTextField
            .bind(to: dogBirthdayDatePicker.rx.date)
            .disposed(by: disposeBag)
        
        viewModel.weekdayQuantityTextField
                    .drive(weekdayTextField.rx.text)
                    .disposed(by: disposeBag)
        
                viewModel.weekendQuantityTextField
                    .drive(weekendTextField.rx.text)
                    .disposed(by: disposeBag)
        
        dogNameTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(dogNameTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: "")
            .bind(onNext: viewModel.dogNameFieldChanged)
            .disposed(by: disposeBag)
        
        dogBreedTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(dogBreedTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: "")
            .bind(onNext: viewModel.dogBreedFieldChanged)
            .disposed(by: disposeBag)
        
        dogBirthdayDatePicker.rx.controlEvent(.valueChanged)
            .withLatestFrom(dogBirthdayDatePicker.rx.date)
            .distinctUntilChanged()
            .bind(onNext: viewModel.dogBirthdayFieldChanged)
            .disposed(by: disposeBag)
        
        weekdayTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(weekdayTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: "")
            .bind(onNext: viewModel.weekdayQuantityChanged)
            .disposed(by: disposeBag)

        weekendTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(weekendTextField.rx.text)
            .distinctUntilChanged()
            .replaceNil(with: "")
            .bind(onNext: viewModel.weekendQuantityChanged)
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .bind(onNext: viewModel.createPetTapped)
            .disposed(by: disposeBag)
    }
    
    @objc func keyboardWillShow(_: Notification) {
        let firstResponder: UIView
        if dogNameTextField.isFirstResponder {
            firstResponder = dogNameTextField
        } else if dogBreedTextField.isFirstResponder {
            firstResponder = dogBreedTextField
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

extension PetAdditionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageUrl = info[.editedImage] as? UIImage {
            
            dogPicture.setImage(imageUrl, for: .normal)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

