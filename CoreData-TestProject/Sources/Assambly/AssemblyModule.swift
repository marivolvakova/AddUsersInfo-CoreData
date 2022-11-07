//
//  AssemblyModule.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 24.08.2022.
//

import Foundation
import UIKit


// MARK: - ModuleAssemblyProtocol

protocol ModuleAssemblyProtocol {
    func createUsersModule(router: UsersRouterProtocol) -> UIViewController
    func createDetailedModule(router: UsersRouterProtocol, user: User?) -> UIViewController
}

//MARK: - AssemblyModule

class AssemblyModule: ModuleAssemblyProtocol {
    func createUsersModule(router: UsersRouterProtocol) -> UIViewController {
        let view = UsersViewController()
        let presenter = UsersPresenter(view: view,
                                       coreDataService: CoreDataService.sharedManager,
                                       router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailedModule(router: UsersRouterProtocol, user: User?) -> UIViewController {
        let view = DetailedViewController()
        let presenter = DetailedPresenter(view: view,
                                          coreDataService: CoreDataService.sharedManager,
                                        router: router,
                                            user: user)
        view.presenter = presenter
        return view
    }
}
