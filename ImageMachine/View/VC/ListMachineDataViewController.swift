//
//  ListMachineDataViewController.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import UIKit

class ListMachineDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
    }
    
    func setupNavBar() {
        self.title = "Machine Data"
    }
    
    func setupTable() {
        self.tableView.register(UINib(nibName: "MachineDataCell", bundle: nil), forCellReuseIdentifier: "MachineDataCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
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
