//
//  DetailedUserPresenter.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 24.08.2022.
//

import UIKit


protocol DetailedViewProtocol: AnyObject {
    func loadUserInfoFromCoredata()
}


protocol DetailedPresenterProtocol: AnyObject {
    var userInfo: User? { get set }
    init(view: DetailedViewProtocol, coreDataService: CoreDataProtocol, router: UsersRouterProtocol, user: User?)
    
    func getUserInfo()
    func backButtonTapped()
    func saveUserInfoInCoreData(user: User, newName: String?, newCityName: String?, newDateOfBirth: String?, newPhoneNumber: String?, newPhoto: Data?)
}


class DetailedPresenter: DetailedPresenterProtocol {
    // MARK: - Properties

    var userInfo: User?
    
    weak var view: DetailedViewProtocol?
    private let coreDataService: CoreDataProtocol
    private var router: UsersRouterProtocol?

    // MARK: - Initialize
    
    required init(view: DetailedViewProtocol, coreDataService: CoreDataProtocol, router: UsersRouterProtocol, user: User?) {
        self.view = view
        self.coreDataService = coreDataService
        self.router = router
        self.userInfo = user
    }
        
        // MARK: - Functions
        
        func getUserInfo() {
            view?.loadUserInfoFromCoredata()
        }
        
        func saveUserInfoInCoreData(user: User, newName: String?, newCityName: String?, newDateOfBirth: String?, newPhoneNumber: String?, newPhoto: Data?) {
            
            coreDataService.saveDetailedInfo(user: user, newName: newName, newCityName: newCityName, newDateOfBirth: newDateOfBirth, newPhoneNumber: newPhoneNumber, newPhoto: newPhoto)
        }
        
        func backButtonTapped() {
            router?.popToRoot()
        }
}
