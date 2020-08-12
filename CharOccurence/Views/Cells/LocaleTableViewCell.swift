//
//  LocaleTableViewCell.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 11.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class LocaleTableViewCell: UITableViewCell {

    @IBOutlet weak var localePicker: UITextField!
    
    static let identifier = "LocaleTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
