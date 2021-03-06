//
//  AppDelegate.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        checkAuth()
        return true
    }
    
    private func checkAuth() {
        let storyboard = UIStoryboard(name: APIManager.shared.checkApiKey() ? "Main" : "Auth", bundle: nil)
        
        let initialVC = storyboard.instantiateViewController(withIdentifier: "Initial")
        
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()
    }
}

