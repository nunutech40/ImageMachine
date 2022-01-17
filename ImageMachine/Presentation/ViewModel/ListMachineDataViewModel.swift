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
    
    func addOnceData(machineData: MachineDataModel, tableView: UITableView) {
        self.repository.saveMachineData(from: machineData)
            .subscribe (
                onNext: { value in
                    self.getListMachineData(tableView: tableView)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getListMachineData(tableView: UITableView) {
        self.repository.getListMachineData()
            .asObservable()
            .subscribe(
                onNext: { value in
                    self.machineDatalist = value
                    tableView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    func deleteMachineDataById(id: String, tableView: UITableView) {
        self.repository.deleteMachineData(id: id)
            .subscribe (
                onNext: { value in
                    self.getListMachineData(tableView: tableView)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getMcahineDataByQrCode(qrCode: String, _ vc: ListMachineDataViewController, completion: @escaping (Bool) -> Void) {
        self.repository.getMachineDataByQrCode(qrcode: qrCode)
            .asObservable()
            .subscribe(
                onNext: { value in
                    self.machineDatalist = value
                    guard (self.machineDatalist.count > 0) else {
                        completion(true)
                        return
                    }
                    completion(false)
                },
                onError: {_ in
                    completion(false)
                }
            )
            .disposed(by: disposeBag)
        
    }
    
    
}
