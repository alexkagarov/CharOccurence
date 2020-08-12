//
//  Constants.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

struct URLs {
    static let Server = "https://apiecho.cf/api"
    
    static let GetText = "/get/text/"
    
    static let SignUp = "/signup/"
    static let Login = "/login/"
    static let Logout = "/logout/"
    
}

struct Segues {
    static let ToAuthType = "ToAuthTypeSegue"
    static let ToMain = "ToMainSegue"
    static let ToAuth = "ToAuthSegue"
}

struct UDKeys {
    static let Token = "UserDefaults.AccessToken"
}

struct CustomColors {
    static let WhiteToBlack = UIColor(named: "White-to-Black")
    static let BlackToWhite = UIColor(named: "Black-to-White")
}
