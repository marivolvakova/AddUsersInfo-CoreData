//
//  UserViewController.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 23.08.2022.
//

import UIKit

class UsersViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: UsersPresenterProtocol!
    
    private var usersView: UsersView? {
        guard isViewLoaded else { return nil }
        return view as? UsersView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = UsersView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.getUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchTableView()
    }
    
    // MARK: - Setup functions
    
    private func setupView() {
        
        title = "Users"
        
        usersView?.tableView.delegate = self
        usersView?.tableView.dataSource = self
        usersView?.tableView.keyboardDismissMode = .onDrag
        
        
        usersView?.textField.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        usersView?.button.addTarget(self,
                                    action: #selector(addNewUserButtonAction),
                                    for: .touchUpInside)
    }
    
    // MARK: - Functions
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

    // MARK: - UsersViewProtocol

extension UsersViewController: UsersViewProtocol {
    @objc func addNewUserButtonAction() {
        guard let newUser = usersView?.textField.text else { return }
        
        if newUser.isEmpty {
            showAlert(message: "Print the name in the box first!")
        } else {
            presenter?.saveNewUser(name: newUser)
            usersView?.textField.text = ""
            usersView?.textField.resignFirstResponder()
            showAlert(message: "New user \(newUser) has been added")
        }
    }
    
    func fetchTableView() {
        DispatchQueue.main.async {
            self.usersView?.tableView.reloadData()
        }
    }
}

    // MARK: - TableViewDataSource, TableViewDelegate

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CoreDataService.sharedManager.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentUser = CoreDataService.sharedManager.users?[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = currentUser?.name
        cell.detailTextLabel?.text = currentUser?.cityName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action,
                                                                        view,
                                                                        completionHandler)  in
            guard let selectedUser = CoreDataService.sharedManager.users?[indexPath.row] else { return }
            self?.presenter?.deleteUser(user: selectedUser)
            self?.usersView?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.showAlert(message: "User deleted")
        completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = CoreDataService.sharedManager.users?[indexPath.row]
        presenter.selectedUser(user: selectedUser)
    }
}

    // MARK: - TextFieldDelegate

extension UsersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addNewUserButtonAction()
        textField.resignFirstResponder()
        return true
    }
}
