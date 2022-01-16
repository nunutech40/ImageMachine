//
//  AppDelegate.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func migrationRealm() {
        let config = Realm.Configuration(
            
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                migration.enumerateObjects(ofType: MachinDataEntity.className()) { oldObject, newObject in
                    if (oldSchemaVersion < 2) {
                        newObject!["primaryKeyProperty"] = "id"
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.migrationRealm()
        return true
    }

}

