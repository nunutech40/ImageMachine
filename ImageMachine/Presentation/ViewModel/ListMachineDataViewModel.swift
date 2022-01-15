//
//  ListMachineDataViewModel.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import RxSwift

class ListMachineDataViewModel {
    
    private var disposeBag = DisposeBag()
    private let repository: MachinesRepository!
    
    @Published var machineDataList: [MachineDataModel] = []
    @Published var errorMessage: String = ""
    @Published var loadingState: Bool = false
    
    init(repository: MachinesRepository) {
        self.repository = repository
    }
    
    func getMachineDataList() {
        self.loadingState = true
        self.repository.getListMachineData() { 
            switch machineData {
            case .success(let listMachineData):
                DispatchQueue.main.async {
                    self.loadingState = false
                    self.machineDataList = listMachineData
                }
            }
        }
    }
    
}
