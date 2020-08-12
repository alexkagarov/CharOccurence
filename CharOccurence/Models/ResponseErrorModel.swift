//
//  ResponseErrorModel.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 11.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

struct ResponseErrorModel: Codable {
    let name: String?
    let message: String?
    let code: Int?
    let status: Int?
    let field: String?
}
