//
//  MainHelper.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import UIKit

class MainHelper {
    
    // static onTap
    static func onTap(_ sender: UIViewController,_ view:UIView,  _ selector:Selector){
        let tapGestures  = UITapGestureRecognizer(target: sender, action: selector)
        view.addGestureRecognizer(tapGestures)
        view.isUserInteractionEnabled    = true
    }
}
