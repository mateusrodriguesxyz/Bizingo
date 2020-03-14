//
//  AppDelegate.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 31/01/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(nil, forKey: "name")
        UserDefaults.standard.set(nil, forKey: "number")
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        SCKManager.shared.establishConnection()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        SCKManager.shared.closeConnection()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
//            SCKManager.shared.exit(with: nickname, completionHandler: nil)
//        }
    }

}

