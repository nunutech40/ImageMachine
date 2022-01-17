//
//  MachineDataCell.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import UIKit

class MachineDataCell: UITableViewCell {
    
    @IBOutlet weak var machineNameLbl: UILabel!
    @IBOutlet weak var machineTypeLbl: UILabel!
    @IBOutlet weak var deleteIcon: UIImageView!
    
    var delegate: ProtoclDeleteMachine!
    var machineId: Int!
    
    func configureCell() {
        MainHelper.onTap(self, deleteIcon, #selector(deleteTap(_:)))
    }
    
    @objc func deleteTap(_ gesture: UITapGestureRecognizer) {
        self.delegate.didDelete(machineId: self.machineId)
    }
}
