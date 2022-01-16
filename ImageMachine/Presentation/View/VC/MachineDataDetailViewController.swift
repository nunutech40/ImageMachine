//
//  MachineDataDetailViewController.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import UIKit
import RxSwift
import RxCocoa

class MachineDataDetailViewController: UIViewController {
    
    // OUTLET HERE
    @IBOutlet weak var machineDataId: UILabel!
    @IBOutlet weak var machineDataName: UILabel!
    @IBOutlet weak var machineDataType: UILabel!
    @IBOutlet weak var machineDataQRCode: UILabel!
    
    // VARIABLE HERE
    var machineId: Int?
    private var disposeBag = DisposeBag()
    var viewModel: MachineDataDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInjection()
        self.setupNavBar()
        self.setupData()
    }
    
    func setupInjection() {
        let inject = Injection.init().provideRepository()
        self.viewModel = MachineDataDetailViewModel(repository: inject)
    }
    
    func setupNavBar() {
        self.navigationItem.title = "Machinde Data Detail"
        
        let itemRight = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(rightTapNavBar))
        self.navigationItem.setRightBarButton(itemRight, animated: true)
    }
    
    func setupData() {
        self.viewModel?.getMcahineDataById(id: "\(self.machineId ?? 0)", self)
    }

}

extension MachineDataDetailViewController {
    
    @objc func rightTapNavBar(_ gestureTap: UITapGestureRecognizer) {
        print("cek right")
    }
    
}
