//
//  CustomErr+Ext.swift
//  ImageMachine
//
//  Created by mac on 15/1/22.
//

import Foundation

enum DatabaseError: LocalizedError {

  case invalidInstance
  case requestFailed
  
  var errorDescription: String? {
    switch self {
    case .invalidInstance: return "Database can't instance."
    case .requestFailed: return "Your request failed."
    }
  }

}
