//
//  Constants.swift
//  CharOccurence
//
//  Created by Mac on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

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
}

struct UDKeys {
    static let Token = "UserDefaults.AccessToken"
}
