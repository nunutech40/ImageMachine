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
    
    func getMcahineDataById(id: String, _ vc: MachineDataDetailViewController) {
        self.repository.getMachineDataById(id: id)
            .asObservable()
            .subscribe(
                onNext: { value in
                    self.machineDatalist = value
                    
                    guard (self.machineDatalist.count > 0) else {
                        return
                    }
                    self.setupData(vc, data: self.machineDatalist[0])
                    vc.collectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    func updateDataById(id: String, machineData: MachineDataModel, _ vc: MachineDataDetailViewController) {
        self.repository.saveMachineData(from: machineData)
            .subscribe (
                onNext: { value in
                    self.getMcahineDataById(id: id, vc)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getMcahineDataByQrCode(qrCode: String, _ vc: MachineDataDetailViewController, completion: @escaping (Bool) -> Void) {
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
    
    func setupData(_ vc: MachineDataDetailViewController, data: MachineDataModel) {
        vc.machineDataId.text = "Machine ID: \(data.machineId ?? 0)"
        vc.machineDataName.text = data.machineName
        vc.machineDataType.text = data.machineType
        vc.machineDataQRCode.text = data.machineQRCode
    }
    
}

