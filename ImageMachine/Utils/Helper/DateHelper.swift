//
//  DateHelper.swift
//  ImageMachine
//
//  Created by mac on 17/1/22.
//

import UIKit

class DateHelper {
    
    static let locale           = Locale(identifier: "id_ID")
    static let timezone         = TimeZone.current
    
    public static func setInputView(_ sender:UIViewController, _ textField:UITextField, _ selector:Selector){
        let datePickerView              = UIDatePicker()
        datePickerView.datePickerMode   = .date
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        textField.inputView             = datePickerView
        datePickerView.addTarget(sender, action: selector, for: .valueChanged)
    }
    
    public static func localFormatter(_ pattern:String) -> DateFormatter {
        let formatter           = DateFormatter()
        formatter.dateFormat    = pattern
        formatter.locale        = locale
        formatter.timeZone      = timezone
        return formatter
    }
    
}
