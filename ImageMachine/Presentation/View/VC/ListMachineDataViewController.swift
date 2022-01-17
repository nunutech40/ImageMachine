//
//  ListMachineDataViewController.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ListMachineDataViewController: UIViewController {
    
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListMachineDataViewModel?
    private var disposeBag = DisposeBag()
    var isSortType: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInjection()
        self.setupNavBar()
        self.setupTable()
        self.setupView()
        self.setupTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupTable()
    }
    
    func setupInjection() {
        let inject = Injection.init().provideRepository()
        viewModel = ListMachineDataViewModel(repository: inject)
    }
    
    func setupNavBar() {
        //let navBarItem
        let itemRight = UIBarButtonItem(title: "Add New", style: .plain, target: self, action: #selector(rightTapNavBar))
        self.navigationItem.setRightBarButton(itemRight, animated: true)
        
        let itemLeft = UIBarButtonItem(image: UIImage(named:"sortIcon"), style: .plain, target: self, action: #selector(leftTapNavBar))
        self.navigationItem.setLeftBarButton(itemLeft, animated: true)
        
        self.navigationItem.title = "List Machine Data"
    }
    
    func setupView() {
        self.scanView.roundedView()
    }
    
    func setupTable() {
        self.viewModel?.getListMachineData(tableView: self.tableView)
        self.tableView.register(UINib(nibName: "MachineDataCell", bundle: nil), forCellReuseIdentifier: "MachineDataCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupTap() {
        MainHelper.onTap(self, self.scanView, #selector(tapToScan(_:)))
    }
    
}

extension ListMachineDataViewController {
    
    @objc func leftTapNavBar(_ gestureTap: UITapGestureRecognizer) {
        self.isSortType = !isSortType
        
        if isSortType {
            let sortedObjects = self.viewModel?.machineDatalist.sorted { (l, r) in
                l.machineType ?? "" < r.machineType ?? ""
            }
            self.viewModel?.machineDatalist = sortedObjects ?? []
        } else {
            let sortedObjects = self.viewModel?.machineDatalist.sorted { (l, r) in
                l.machineName ?? "" < r.machineName ?? ""
            }
            self.viewModel?.machineDatalist = sortedObjects ?? []
        }
        
        self.tableView.reloadData()
    }
    
    @objc func rightTapNavBar(_ gestureTap: UITapGestureRecognizer) {
        self.inputNewMachinePopUp()
    }
    
    @objc func tapToScan(_ gesture: UITapGestureRecognizer) {
        let destVC = MainHelper.instantiateVC(UIStoryboard(name: "Main", bundle: nil), "ScanQRCodeViewController") as! ScanQRCodeViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func inputNewMachinePopUp() {
        let alert = UIAlertController(title: "Add", message: "Add Name And Type Machine", preferredStyle: .alert)
        alert.addTextField { (nameText) in
            nameText.text = ""
            nameText.placeholder = "Enter Machine Name"
        }
        alert.addTextField { (typeName) in
            typeName.text = ""
            typeName.placeholder = "Enter Type Name"
        }
        
        alert.addTextField { (qrcodeText) in
            qrcodeText.text = ""
            qrcodeText.placeholder = "Enter Type Name"
            qrcodeText.keyboardType = .numberPad
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            let textFieldName = alert.textFields![0]
            let textFieldType = alert.textFields![1]
            let textQrCode = alert.textFields![2]

            var machineDataModel = MachineDataModel()
            machineDataModel.machineId = MachinDataEntity().IncrementaID()
            
            if let strName = textFieldName.text {
                machineDataModel.machineName = strName
            }
            
            if let strType = textFieldType.text {
                machineDataModel.machineType = strType
            }
            
            if let strQRCode = textQrCode.text {
                machineDataModel.machineQRCode = strQRCode
            }
            
            self.viewModel?.addOnceData(machineData: machineDataModel, tableView: self.tableView)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Nothing");
        }
        
        alert.addAction(OKAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupAlert(message: String ){
        let alert = UIAlertController(title: "Input Data", message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension ListMachineDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.machineDatalist.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MachineDataCell", for: indexPath) as! MachineDataCell
        let data = self.viewModel?.machineDatalist[indexPath.row]
        cell.machineNameLbl.text = data?.machineName
        cell.machineTypeLbl.text = data?.machineType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel?.machineDatalist[indexPath.row]
        let destVC = MainHelper.instantiateVC(UIStoryboard(name: "Main", bundle: nil), "MachineDataDetailViewController") as! MachineDataDetailViewController
        destVC.machineId = data?.machineId
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
}
