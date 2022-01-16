//
//  MachineDataDetailViewModel.swift
//  ImageMachine
//
//  Created by mac on 16/1/22.
//

import RxSwift
import RxCocoa

class MachineDataDetailViewModel {
    
    private var disposeBag = DisposeBag()
    private let repository: MachinesRepository!
    var machineDatalist: [MachineDataModel] = []
    
    init(repository: MachinesRepository) {
        self.repository = repository
    }
    
    func getMcahineDataById(id: String) {
        self.repository.getMachineDataById(id: id)
            .asObservable()
            .subscribe(
                onNext: { value in
                    self.machineDatalist = value
                }
            )
            .disposed(by: disposeBag)
    }
    
}

