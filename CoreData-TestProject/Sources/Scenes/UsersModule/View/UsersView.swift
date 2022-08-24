//
//  UsersView.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 23.08.2022.
//

import UIKit

class UsersView: UIView {
    
    // MARK: - Properties
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = 40
        tableView.layer.cornerRadius = 10
        tableView.tintColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.placeholder = "Print name here"
        textField.backgroundColor = .systemGray5
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
        
    }()
    
    var button: UIButton = {
        let button = UIButton()
        button.setTitle("Add user", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupHierarchy() {
        addSubview(textField)
        addSubview(button)
        addSubview(tableView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 45),
            
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
