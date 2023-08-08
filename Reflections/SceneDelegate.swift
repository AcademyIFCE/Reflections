//
//  SceneDelegate.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let splitVC: UISplitViewController = {
        let splitVC = UISplitViewController(style: .doubleColumn)
        splitVC.primaryBackgroundStyle = .sidebar
        splitVC.preferredDisplayMode = .twoBesideSecondary
        splitVC.setViewController(ReflectionListViewController(), for: .primary)
        splitVC.setViewController(EmptyReflectionViewController(), for: .secondary)
        return splitVC
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)

        #if targetEnvironment(macCatalyst)
        self.window?.rootViewController = splitVC
        #else
        if UIDevice.current.model == "iPhone" {
            self.window?.rootViewController = UINavigationController(rootViewController: ReflectionListViewController())
        } else {
            self.window?.rootViewController = splitVC
        }
        #endif
        
        self.window?.makeKeyAndVisible()
    }
    
    @objc private func rotated() {
        print("rotated")
        if window?.traitCollection.horizontalSizeClass == .regular {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }

}
