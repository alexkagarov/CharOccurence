//
//  UserResponseModel.swift
//  CharOccurence
//
//  Created by Mac on 11.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

struct UserResponseModel: Codable {
    let success: Bool
    let data: UserModel?
    let errors: [ResponseErrorModel]?
}
