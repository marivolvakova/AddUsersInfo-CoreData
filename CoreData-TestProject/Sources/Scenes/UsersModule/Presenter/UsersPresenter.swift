//
//  UsersPresenter.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 23.08.2022.
//
import Foundation

// MARK: - UsersViewProtocol

protocol UsersViewProtocol: AnyObject {
    func fetchTableView()
    func addNewUserButtonAction()
}

// MARK: - UsersPresenterProtocol

protocol UsersPresenterProtocol: AnyObject {

    init(view: UsersViewProtocol, coreDataService: CoreDataProtocol, router: UsersRouterProtocol)
    
    func getUsers()
    func saveNewUser(name: String)
    func deleteUser(user: User)
    func selectedUser(user: User?)
}

// MARK: - UsersPresenter

class UsersPresenter: UsersPresenterProtocol {

    // MARK: - Properties

    weak var view: UsersViewProtocol?
    private let coreDataService: CoreDataProtocol
    private var router: UsersRouterProtocol?

    // MARK: - Initialize
    
    required init(view: UsersViewProtocol, coreDataService: CoreDataProtocol, router: UsersRouterProtocol) {
        self.view = view
        self.coreDataService = coreDataService
        self.router = router
    }

    // MARK: - Functions

    func getUsers() {
        view?.fetchTableView()
    }

    func saveNewUser(name: String) {
        coreDataService.saveNewUser(name: name)
        view?.fetchTableView()
    }

    func deleteUser(user: User) {
        coreDataService.deleteUser(user: user)
        view?.fetchTableView()
    }

    func selectedUser(user: User?) {
        router?.showDetailedViewController(user: user)
    }
}
