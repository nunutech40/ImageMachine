//
//  RealmManager.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import Foundation
import RealmSwift
import RxSwift

protocol MachineDataLocaleProtocol: class {
    func saveMachineData(from machineData: MachinDataEntity) -> Observable<Bool>
    func updateMachindeData(from machineData: MachinDataEntity) -> Observable<Bool>
    func deleteMachineData(id: Int) -> Observable<Bool>
    func getListMachineData() -> Observable<[MachinDataEntity]>
    func getMachineDataById(id: Int) -> Observable<[MachinDataEntity]>
}



final class MachineDataLocalDataSource: NSObject {

    
    
}

extension MachineDataLocalDataSource: MachineDataLocaleProtocol {
    
    func saveMachineData(from machineData: MachinDataEntity) -> Observable<Bool> {
        <#code#>
    }
    
    func updateMachindeData(from machineData: MachinDataEntity) -> Observable<Bool> {
        <#code#>
    }
    
    func deleteMachineData(id: Int) -> Observable<Bool> {
        <#code#>
    }
    
    func getListMachineData() -> Observable<[MachinDataEntity]> {
        <#code#>
    }
    
    func getMachineDataById(id: Int) -> Observable<[MachinDataEntity]> {
        <#code#>
    }
    
    
}
