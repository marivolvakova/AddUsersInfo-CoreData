//
//  DetailedView.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 24.08.2022.
//

import UIKit

class DetailedView: UIView {
    
    // MARK: - Properties
    
    let imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    lazy var photoImage: UIImageView = {
        let photoImage = UIImageView()
        photoImage.layer.masksToBounds = true
        photoImage.contentMode = .scaleAspectFill
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.layer.cornerRadius = 125
        photoImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        photoImage.widthAnchor.constraint(equalToConstant: 250).isActive = true
        photoImage.clipsToBounds = true
        photoImage.backgroundColor = .darkGray
        photoImage.isUserInteractionEnabled = false
        photoImage.image = UIImage(named: "noImage")
        return photoImage
    }()
    
    lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.setTitle("Edit information", for: .normal)
        editButton.layer.cornerRadius = 10
        editButton.backgroundColor = .systemBlue
        editButton.titleLabel?.textColor = .white
        editButton.tintColor = .black
        editButton.translatesAutoresizingMaskIntoConstraints = false
        return editButton
    }()
    
    lazy var changePhotoLable: UILabel = {
        let lable = UILabel()
        lable.text = "Tap the photo to change it"
        lable.textAlignment = .center
        lable.textColor = .black
        lable.font = .systemFont(ofSize: 14, weight: .regular)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.isHidden = true
        lable.clipsToBounds = true
        return lable
    }()
    
    lazy var nameTextField = createTextField(placeholder: "Your name")
    lazy var dateOfBirthTextField = createTextField(placeholder: "Your date of birth")
    lazy var cityNameTextField = createTextField(placeholder: "Your city")
    lazy var phoneNumberTextField = createTextField(placeholder: "Your phone number")
    
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.placeholder = placeholder
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.layer.cornerRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardAppearance = .default
        textField.keyboardType = .default
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        return textField
    }
    
    // MARK: - Initial

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    // MARK: - Settings
    
    func setupHierarchy() {
        self.addSubview(changePhotoLable)
        self.addSubview(photoImage)
        self.addSubview(nameTextField)
        self.addSubview(dateOfBirthTextField)
        self.addSubview(cityNameTextField)
        self.addSubview(phoneNumberTextField)
        self.addSubview(editButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            changePhotoLable.bottomAnchor.constraint(equalTo: photoImage.topAnchor, constant: -5),
            changePhotoLable.centerXAnchor.constraint(equalTo: photoImage.centerXAnchor),
            
            photoImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            photoImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        
            nameTextField.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            dateOfBirthTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            cityNameTextField.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 10),
            cityNameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            cityNameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: cityNameTextField.bottomAnchor, constant: 10),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            editButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            editButton.centerXAnchor.constraint(equalTo: phoneNumberTextField.centerXAnchor),
            editButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40)
        ])
    }
    
    private func setupView() {
        backgroundColor = .systemGroupedBackground
    }
}

