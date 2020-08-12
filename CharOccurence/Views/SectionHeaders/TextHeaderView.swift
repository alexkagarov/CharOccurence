//
//  TextHeaderView.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 12.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

protocol TextHeaderViewDelegate: class {
    func showTextTapped()
}

class TextHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var generatedTextHeaderButton: UIButton!
    
    weak var delegate: TextHeaderViewDelegate?
    
    static let identifier = "TextHeaderView"
    
    @IBAction func onShowTextTapped(_ sender: UIButton) {
        delegate?.showTextTapped()
    }
}
