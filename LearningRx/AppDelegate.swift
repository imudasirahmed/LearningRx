//
//  AppDelegate.swift
//  LearningRx
//
//  Created by Mudasir Ahmed on 4/30/19.
//  Copyright © 2019 Mudasir Ahmed. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ModelLayer.shared.initDatabase()
        
//        SimpleRx.shared.variables()
//        SimpleRx.shared.subjects()
//        SimpleRx.shared.basicObservables()
//        SimpleRx.shared.creatingObservables()
//        SimpleRx.shared.creatingUselessObservable()

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

