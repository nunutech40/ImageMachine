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
    @IBOutlet weak var editNamaIcon: UIImageView!
    @IBOutlet weak var editTypeIcon: UIImageView!
    @IBOutlet weak var editQRCodeIcon: UIImageView!
    
    // VARIABLE HERE
    var machineId: Int?
    private var disposeBag = DisposeBag()
    var viewModel: MachineDataDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInjection()
        self.setupNavBar()
        self.setupData()
        self.setupTap()
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
    
    func setupTap() {
        MainHelper.onTap(self, editNamaIcon, #selector(tapEditNama(_:)))
        MainHelper.onTap(self, editTypeIcon, #selector(tapEditType(_:)))
        MainHelper.onTap(self, editQRCodeIcon, #selector(tapEditQRCode(_:)))
    }
    
}

extension MachineDataDetailViewController {
    
    @objc func rightTapNavBar(_ gestureTap: UITapGestureRecognizer) {
        print("cekkk right")
    }
    
    @objc func tapEditNama(_ gesture: UITapGestureRecognizer) {
        self.inputTextAlert(message: "Edit Your Name Machine Data", placeholder: "Input New Name...", statusEdit: "name")
    }
    
    @objc func tapEditType(_ gesture: UITapGestureRecognizer) {
        self.inputTextAlert(message: "Edit Your Type Machine Data", placeholder: "Input New Type...", statusEdit: "type")
    }
    
    @objc func tapEditQRCode(_ gesture: UITapGestureRecognizer) {
        self.inputTextAlert(message: "Edit Your QRCode Machine Data", placeholder: "Input New QRCode Number", statusEdit: "qrcode")
    }
    
    func inputTextAlert(
        message: String,
        placeholder: String?,
        statusEdit: String?
    ) {
        let alert = UIAlertController(title: "Edit", message: message, preferredStyle: .alert)
        alert.addTextField { (textInput) in
            textInput.text = ""
            textInput.placeholder = placeholder
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            let textFieldName = alert.textFields![0]
            
            var machineDataModel = MachineDataModel()
            machineDataModel.machineId = self.machineId ?? 0
            machineDataModel.machineName = self.viewModel?.machineDatalist[0].machineName
            machineDataModel.machineType = self.viewModel?.machineDatalist[0].machineType
            machineDataModel.machineQRCode = self.viewModel?.machineDatalist[0].machineQRCode
            
            if let strText = textFieldName.text {
                switch statusEdit {
                case "name":
                    machineDataModel.machineName = strText
                case "type":
                    machineDataModel.machineType = strText
                case "qrcode":
                    machineDataModel.machineQRCode = strText
                default:
                    print("do nothing")
                }
                self.viewModel?.updateDataById(id: "\(self.machineId ?? 0)", machineData: machineDataModel, self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Nothing");
        }
        
        alert.addAction(OKAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
