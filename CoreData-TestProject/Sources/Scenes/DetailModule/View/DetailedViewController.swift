//
//  ViewController.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 23.08.2022.
//

import UIKit
import CoreData

class DetailedViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var userInfo: User?
    var viewIsEditing = false
    
    
    var presenter: DetailedPresenterProtocol!
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnImage))
    
    private var detailedView: DetailedView? {
        guard isViewLoaded else { return nil }
        return view as? DetailedView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = DetailedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.getUserInfo()
    }
    
    // MARK: - Private functions
    
    func setupView() {
        setupDelegate()
         
        detailedView?.dateOfBirthTextField.datePicker(target: self,
                                                  doneAction: #selector(doneAction),
                                                  cancelAction: #selector(cancelAction))
        
        
        detailedView?.editButton.addTarget(self,
                                           action: #selector(editButtonAction),
                                           for: .touchUpInside)
        
        detailedView?.photoImage.addGestureRecognizer(tapGesture)

    }
    
    func setupDelegate() {
        detailedView?.imagePicker.delegate = self
        
        detailedView?.nameTextField.delegate = self
        detailedView?.dateOfBirthTextField.delegate = self
        detailedView?.cityNameTextField.delegate = self
        detailedView?.phoneNumberTextField.delegate = self
    }
    

    func setupImagePickerAlert() -> UIAlertController {
        let imagePickerAlert = UIAlertController (title: "Загрузить", message: nil, preferredStyle: .actionSheet)
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        let actionPhoto = UIAlertAction(title: "С фотогалереи", style: .default) { (alert) in
            self.present(self.detailedView?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        }
        imagePickerAlert.addAction(actionCancel)
        imagePickerAlert.addAction(actionPhoto)

        return imagePickerAlert
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
    
    @objc func tapOnImage() {
        present(detailedView?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        present(setupImagePickerAlert(), animated: true, completion: nil)
    }
    
    func editingViewSetup() {
        view.backgroundColor = (viewIsEditing == true) ? .lightGray : .systemGroupedBackground
        detailedView?.editButton.setTitle((viewIsEditing == true) ? "Save information" : "Edit information", for: .normal)
        detailedView?.editButton.backgroundColor = (viewIsEditing == true) ? .darkGray : .systemBlue
        detailedView?.changePhotoLable.isHidden = (viewIsEditing == true) ? false : true
        detailedView?.photoImage.isUserInteractionEnabled = (viewIsEditing == true) ? true : false
    }
    
    @objc func editButtonAction() {
        viewIsEditing = true
        editingViewSetup()
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
        
        ///Если строка имени пустая - не сохранять запись и показать алерт
        if (detailedView?.nameTextField.text!.isEmpty)! {
            showAlert(message: "Data has not been saved, because the name field is empty!")
        } else {
            viewIsEditing = false
            editingViewSetup()
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

func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return viewIsEditing == true ? true : false
}

func showAlert(message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
}
}

extension DetailedViewController: DetailedViewProtocol {
    func loadUserInfoFromCoredata() {
        ///Textfields
        detailedView?.nameTextField.text = presenter.userInfo?.name
        detailedView?.dateOfBirthTextField.text = presenter.userInfo?.dateOfBirth?.convertToString()
        detailedView?.cityNameTextField.text = presenter.userInfo?.cityName
        detailedView?.phoneNumberTextField.text = presenter.userInfo?.phoneNumber
        ///Photo image
        detailedView?.photoImage.image = UIImage(data: presenter.userInfo?.photo ?? Data())
    }
}


extension UITextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 300))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
    
    
}


extension DetailedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        detailedView?.imagePicker.dismiss(animated: true)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            detailedView?.photoImage.image = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        detailedView?.imagePicker.dismiss(animated: true)
    }
}


extension Date {
    public func convertToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}


extension String {

    public func convertToDate() -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: self)
    }
}
