//
//  ListMachineDataViewModel.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import RxSwift
import RxCocoa

class ListMachineDataViewModel {
    
    private var disposeBag = DisposeBag()
    private let repository: MachinesRepository!
    var machineDatalist: [MachineDataModel] = []
    
    init(repository: MachinesRepository) {
        self.repository = repository
    }
    
    func addOnceData() {
        var object = MachineDataModel()
        object.machineId = MachinDataEntity().IncrementaID()
        object.machineName = "Me And You"
        object.machineType = "Hollidays"
        object.machineQRCode = "88999"
        
        self.repository.saveMachineData(from: object)
            .subscribe (
                onNext: { value in
                    print("cek valuueee: \(value)")
                    self.getListMachineData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getListMachineData() {
        self.repository.getListMachineData()
            .map { self.machineDatalist = $0 }
            .subscribe(
                onNext: { value in
                    print("cek valuueee: \(value)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    
    
}
