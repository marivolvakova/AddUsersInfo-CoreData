//
//  SceneDelegate.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 23.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()
        let assemblyModule = AssemblyModule()
        let router = Router(navigationController: navigationController, assemblyModule: assemblyModule)
        router.initializeViewControllers()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

