//
//  MachineDataEntity.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import Foundation
import RealmSwift

class MachinDataEntity: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var qrCode = ""
    @objc dynamic var createAt = ""
    @objc dynamic var updateAt = ""
    let urpPaths = List<String>()
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(MachinDataEntity.self).sorted(byKeyPath: "id", ascending: false).first?.id {
            return retNext + 1
        }else{
            return 1
        }
    }
}
