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
    
    static func onTap(_ sender: UITableViewCell,_ view:UIView,  _ selector:Selector){
        let tapGestures  = UITapGestureRecognizer(target: sender, action: selector)
        view.addGestureRecognizer(tapGestures)
        view.isUserInteractionEnabled    = true
    }
    
    // next vc // push
    static func instantiateVC(_ storyboard: UIStoryboard, _ id: String) -> UIViewController? {
        if #available(iOS 13.0, *) {
            return storyboard.instantiateViewController(identifier: id)
        } else {
            return storyboard.instantiateViewController(withIdentifier: id)
        }
    }
   
}
