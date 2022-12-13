//
//  SceneDelegate.swift
//  Albuns
//
//  Created by Professor on 22/10/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                self.window?.rootViewController = storyBoard.instantiateInitialViewController()
            self.window?.makeKeyAndVisible()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        do {
         try DataBaseController.sharedInstance.salvar()
        } catch {
        }
    }
}

