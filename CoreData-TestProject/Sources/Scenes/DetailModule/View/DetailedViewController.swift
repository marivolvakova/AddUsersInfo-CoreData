//
//  ViewController.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 23.08.2022.
//

import UIKit
import CoreData

class DetailedViewController: UIViewController {
    
    // MARK: - Properties
    
    var userInfo: User?
    var viewIsEditing = false
    var presenter: DetailedPresenterProtocol!
    
    private var detailedView: DetailedView? {
        guard isViewLoaded else { return nil }
        return view as? DetailedView
    }
    
    lazy var imagePickerAlert: UIAlertController = {
        let imagePickerAlert = UIAlertController (title: "Загрузить", message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let actionPhoto = UIAlertAction(title: "Из фотогалереи", style: .default) { (alert) in
            self.present(self.detailedView?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        }
        imagePickerAlert.addAction(actionCancel)
        imagePickerAlert.addAction(actionPhoto)
        return imagePickerAlert
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = DetailedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.getUserInfo()
    }
    
    // MARK: - Setup functions
    
    func setupView() {
        setupDelegate()
        
        ///Actions for date of birth textField
        detailedView?.dateOfBirthTextField.datePicker(target: self,
                                                  doneAction: #selector(doneAction),
                                                  cancelAction: #selector(cancelAction))
        ///Action for edit button
        detailedView?.editButton.addTarget(self,
                                           action: #selector(editButtonAction),
                                        for: .touchUpInside)
        ///Tap gesture for image selecting
        createTapGesture()
    }
    
    func setupDelegate() {
        detailedView?.imagePicker.delegate = self
        
        detailedView?.nameTextField.delegate = self
        detailedView?.dateOfBirthTextField.delegate = self
        detailedView?.cityNameTextField.delegate = self
        detailedView?.phoneNumberTextField.delegate = self
    }
    
    func createTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnImage))
        detailedView?.photoImage.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Functions
    
    func editSaveViewSetup() {
        view.backgroundColor = (viewIsEditing == true) ? .lightGray : .systemGroupedBackground
        detailedView?.editButton.setTitle((viewIsEditing == true) ? "Save information" : "Edit information", for: .normal)
        detailedView?.editButton.backgroundColor = (viewIsEditing == true) ? .darkGray : .systemBlue
        detailedView?.changePhotoLable.isHidden = (viewIsEditing == true) ? false : true
        detailedView?.photoImage.isUserInteractionEnabled = (viewIsEditing == true) ? true : false
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - @objc functions
    
    @objc func tapOnImage(_ sender: UITapGestureRecognizer) {
        present(imagePickerAlert, animated: true, completion: nil)
    }
    
    ///datePicker actions
    @objc func cancelAction() {
        detailedView?.dateOfBirthTextField.resignFirstResponder()
    }
    
    @objc func doneAction() {
        if let datePickerView = detailedView?.dateOfBirthTextField.inputView as? UIDatePicker {
            detailedView?.dateOfBirthTextField.text = datePickerView.date.convertToString()
            detailedView?.dateOfBirthTextField.resignFirstResponder()
        }
    }
    
    @objc func editButtonAction() {
        viewIsEditing = true
        editSaveViewSetup()
        detailedView?.editButton.addTarget(self,
                                           action: #selector(saveButtonAction),
                                           for: .touchUpInside)
    }
    
    @objc func saveButtonAction() {
        let userInfoName = detailedView?.nameTextField
        let userInfoCityName = detailedView?.cityNameTextField
        let userInfoDateOfBirth = detailedView?.dateOfBirthTextField
        let userInfoPhoneNumber = detailedView?.phoneNumberTextField
        
        let userInfoPhoto = detailedView?.photoImage.image?.jpegData(compressionQuality: 1)
        
        if (detailedView?.nameTextField.text!.isEmpty)! {
            showAlert(message: "Data has not been saved, because the name field is empty!")
        } else {
            viewIsEditing = false
            editSaveViewSetup()
            detailedView?.editButton.addTarget(self,
                                               action: #selector(editButtonAction),
                                               for: .touchUpInside)
            presenter.saveUserInfoInCoreData(user: presenter.userInfo!,
                                             newName: userInfoName?.text,
                                             newCityName: userInfoCityName?.text,
                                             newDateOfBirth: userInfoDateOfBirth?.text,
                                             newPhoneNumber: userInfoPhoneNumber?.text,
                                             newPhoto: userInfoPhoto)
        }
    }
}

    // MARK: - TextFieldDelegate

extension DetailedViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return viewIsEditing == true ? true : false
    }
}

    // MARK: - DetailedViewProtocol

extension DetailedViewController: DetailedViewProtocol {
    func loadUserInfoFromCoredata() {
        ///Textfields
        detailedView?.nameTextField.text = presenter.userInfo?.name
        detailedView?.dateOfBirthTextField.text = presenter.userInfo?.dateOfBirth?.convertToString()
        detailedView?.cityNameTextField.text = presenter.userInfo?.cityName
        detailedView?.phoneNumberTextField.text = presenter.userInfo?.phoneNumber
        ///Photo image
        if let imageData = presenter.userInfo?.photo {
            detailedView?.photoImage.image = UIImage(data: imageData)
        }
    }
}

    // MARK: - ImagePickerControllerDelegate

extension DetailedViewController: UIImagePickerControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        detailedView?.imagePicker.dismiss(animated: true)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            detailedView?.photoImage.image = pickedImage
        }
    }
}

    // MARK: - NavigationControllerDelegate
extension DetailedViewController: UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        detailedView?.imagePicker.dismiss(animated: true)
    }
}



