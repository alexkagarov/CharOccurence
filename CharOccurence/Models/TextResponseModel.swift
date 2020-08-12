//
//  TextResponseModel.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 11.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

struct TextResponseModel: Codable {
    let success: Bool
    let data: String?
    let errors: [ResponseErrorModel]?
}
