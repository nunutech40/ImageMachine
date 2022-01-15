//
//  MachineDataRepository.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import Foundation
import RxSwift

protocol MachinesRepositoryProtocol {
    func saveMachineData(from machineData: MachinDataEntity) -> Observable<Bool>
    //func updateMachindeData(from machineData: MachinDataEntity) -> Observable<Bool>
    //func deleteMachineData(id: Int) -> Observable<Bool>
    func getListMachineData() -> Observable<[MachinDataEntity]>
    func getMachineDataById(id: Int) -> Observable<[MachinDataEntity]>
}

final class MachinesRepository: NSObject {
    
    typealias MachineInstance = (MachineDataLocalDataSource) -> MachinesRepository
    
    fileprivate let locale: MachineDataLocalDataSource
    
    private init(locale: MachineDataLocalDataSource) {
        self.locale = locale
    }
    
    static let sharedInstace: MachineInstance = { localRepo in
        return MachinesRepository(locale: localRepo)
    }
}

extension MachinesRepository: MachinesRepositoryProtocol {
    
}
