//
//  ScanQRCodeViewModel.swift
//  ImageMachine
//
//  Created by mac on 17/1/22.
//

import RxSwift
import RxCocoa

class ScanQRCodeViewModel {
    
    private var disposeBag = DisposeBag()
    private let repository: MachinesRepository!
    var machineDatalist: [MachineDataModel] = []
    
    init(repository: MachinesRepository) {
        self.repository = repository
    }
    
    func getMcahineDataByQrCode(qrCode: String, _ vc: ScanQRCodeViewController, completion: @escaping (Bool) -> Void) {
        self.repository.getMachineDataByQrCode(qrcode: qrCode)
            .asObservable()
            .subscribe(
                onNext: { value in
                    self.machineDatalist = value
                    guard (self.machineDatalist.count > 0) else {
                        completion(false)
                        return
                    }
                    vc.machineId = self.machineDatalist[0].machineId
                    completion(true)
                },
                onError: {_ in
                    completion(false)
                }
            )
            .disposed(by: disposeBag)
        
    }
}
