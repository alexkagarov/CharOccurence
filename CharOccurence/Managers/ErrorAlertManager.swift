//
//  ErrorAlertManager.swift
//  CharOccurence
//
//  Created by Mac on 12.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

class ErrorAlertManager {
    private init() {}
    
    static let shared = ErrorAlertManager()
    
    func alert(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        alert.view.tintColor = CustomColors.BlackToWhite
        
        return alert
    }
}
