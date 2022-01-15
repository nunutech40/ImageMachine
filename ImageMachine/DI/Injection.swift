//
//  Injection.swift
//  ImageMachine
//
//  Created by mac on 16/1/22.
//

import Foundation
import RealmSwift

final class Injection: NSObject {
    
    func provideRepository() -> MachinesRepository {
        let realm = try! Realm()
        let locale: MachineDataLocalDataSource = MachineDataLocalDataSource.sharedInstance(realm)
        return MachinesRepository.sharedInstace(locale)
    }
    
}

