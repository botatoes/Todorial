//
//  AppDelegate.swift
//  Todorial
//
//  Created by Bo-ying Fu on 12/15/18.
//  Copyright © 2018 Botatoes. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        do { _ = try Realm()}
        catch { print("Error initialising new realm, \(error)")}
        
        return true
    }
}

