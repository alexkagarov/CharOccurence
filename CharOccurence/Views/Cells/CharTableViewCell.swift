//
//  CharTableViewCell.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 11.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class CharTableViewCell: UITableViewCell {

    @IBOutlet weak var charLabel: UILabel!
    @IBOutlet weak var occurenceLabel: UILabel!
    
    static let identifier = "CharTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
