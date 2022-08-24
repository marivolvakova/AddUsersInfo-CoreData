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
    
    private func setupView() {
        
        title = "Users"
        
        usersView?.tableView.delegate = self
        usersView?.tableView.dataSource = self
        usersView?.tableView.keyboardDismissMode = .onDrag
        usersView?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        usersView?.textField.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        usersView?.button.addTarget(self,
                                    action: #selector(addNewUserButtonAction),
                                    for: .touchUpInside)
    }
    
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Functions
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
            self.fetchTableView()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CoreDataService.sharedManager.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = CoreDataService.sharedManager.users?[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let selectedUser = CoreDataService.sharedManager.users?[indexPath.row] else { return nil }
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action,
                                                                        swipeButtonView,
                                                                        completion)  in
            self?.presenter?.deleteUser(user: selectedUser)
            self?.usersView?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.showAlert(message: "User deleted")
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedUser = CoreDataService.sharedManager.users?[indexPath.row] else { return }
        presenter.selectedUser(user: selectedUser)
    }
}


extension UsersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addNewUserButtonAction()
        textField.resignFirstResponder()
        return true
    }
}
