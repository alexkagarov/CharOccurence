//
//  TextTableViewCell.swift
//  CharOccurence
//
//  Created by Mac on 11.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var generatedTextLabel: UILabel!
    
    static let identifier = "TextTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
