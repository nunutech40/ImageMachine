//
//  MachineDataRepository.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import Foundation
import RxSwift

protocol MachinesRepositoryProtocol {
    func saveMachineData(from machineData: MachineDataModel) -> Observable<Bool>
    //func updateMachindeData(from machineData: MachinDataEntity) -> Observable<Bool>
    //func deleteMachineData(id: Int) -> Observable<Bool>
    func getListMachineData() -> Observable<[MachineDataModel]>
    func getMachineDataById(id: Int) -> Observable<[MachineDataModel]>
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
    func saveMachineData(from machineData: MachineDataModel) -> Observable<Bool> {
        return self.locale.saveMachineData(from: MachineDataMapper.mapMachineDataModelToEntity(input: machineData))
    }
    
    func getListMachineData() -> Observable<[MachineDataModel]> {
        return self.locale.getListMachineData()
            .map { MachineDataMapper.mapMachineEntityToModel(input: $0) }
    }
    
    func getMachineDataById(id: Int) -> Observable<[MachineDataModel]> {
        return self.locale.getMachineDataById(id: id)
            .map { MachineDataMapper.mapMachineEntityToModel(input: $0) }
    }
    
    
}
