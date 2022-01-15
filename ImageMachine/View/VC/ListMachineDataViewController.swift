//
//  ListMachineDataViewController.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import UIKit

class ListMachineDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ListMachineDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.setupTable()
    }

    
    func setupNavBar() {
        //let navBarItem
        let itemRight = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(rightTapNavBar))
        self.navigationItem.setRightBarButton(itemRight, animated: true)
        
        let itemLeft = UIBarButtonItem(image: UIImage(named:"sortIcon"), style: .plain, target: self, action: #selector(leftTapNavBar))
        self.navigationItem.setLeftBarButton(itemLeft, animated: true)
        
        self.navigationItem.title = "List Machine Data"
    }
    
    func setupTable() {
        self.tableView.register(UINib(nibName: "MachineDataCell", bundle: nil), forCellReuseIdentifier: "MachineDataCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
}

extension ListMachineDataViewController {
    
    @objc func leftTapNavBar(_ gestureTap: UITapGestureRecognizer) {
       print("cekkk left")
    }
    
    @objc func rightTapNavBar(_ gestureTap: UITapGestureRecognizer) {
        self.inputNewMachinePopUp()
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
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            let textFieldName = alert.textFields![0] // Force unwrapping because we know it exists.
            let textFieldType = alert.textFields![1]
            //print("cek type \(textFieldName.text) & \(textFieldType.text)")
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Nothing");
        }
        
        alert.addAction(OKAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ListMachineDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MachineDataCell", for: indexPath) as! MachineDataCell
        cell.machineNameLbl.text = "Folder Kebahagian"
        cell.machineTypeLbl.text = "Wedding"
        return cell
    }
    
    
}
