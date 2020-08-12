//
//  UserModel.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 11.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let email: String?
    let name: String?
    let accessToken: String?
}
