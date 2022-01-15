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
    
    convenience init(machineData: MachineDataModel) {
        self.init()
        self.id = machineData.machineId!
        self.name = machineData.machineName!
        self.type = machineData.machineType!
        self.qrCode = machineData.machineQRCode ?? ""
        self.createAt = machineData.createAt ?? ""
        self.updateAt = machineData.updateAt ?? ""
    }
}
