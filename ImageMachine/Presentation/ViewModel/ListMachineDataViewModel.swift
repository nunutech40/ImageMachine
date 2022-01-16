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
    
    
    
}
