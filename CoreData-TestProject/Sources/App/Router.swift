//
//  Router.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 24.08.2022.
//

import Foundation
import UIKit

// MARK: - RouterProtocol

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyModule: ModuleAssemblyProtocol? { get set }
}

// MARK: - UsersRouterProtocol

protocol UsersRouterProtocol: RouterProtocol {
    func initializeViewControllers()
    func showDetailedViewController(user: User?)
    func popToRoot()
}

// MARK: - Router

class Router: UsersRouterProtocol {
    var navigationController: UINavigationController?
    var assemblyModule: ModuleAssemblyProtocol?

    init(navigationController: UINavigationController, assemblyModule: ModuleAssemblyProtocol) {
        self.navigationController = navigationController
        self.assemblyModule = assemblyModule
    }

    func initializeViewControllers() {
        if let navigationController = navigationController {
            guard let usersViewController = assemblyModule?.createUsersModule(router: self) else { return }
            navigationController.viewControllers = [usersViewController]
        }
    }

    func showDetailedViewController(user: User?) {
        if let navigationController = navigationController {
            guard let detailedViewController =
                    assemblyModule?.createDetailedModule(router: self, user: user) else { return }
            navigationController.pushViewController(detailedViewController, animated: true)
        }
    }

    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
