//
//  Rounded+Ext.swift
//  ImageMachine
//
//  Created by mac on 16/1/22.
//

import Foundation
import UIKit

extension UIView {
    
    func roundedView() {
        self.layer.cornerRadius         = self.frame.size.width/2
        self.clipsToBounds              = true
        self.layer.borderColor          = UIColor.white.cgColor
        self.layer.borderWidth          = 0
    }
    
}
