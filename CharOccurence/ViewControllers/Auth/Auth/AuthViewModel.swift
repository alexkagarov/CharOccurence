//
//  AuthViewModel.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

protocol AuthViewModelProtocol {
    func login(email: String, password: String, success: (()->Void)?, failure: ((String)->Void)?)
    func signUp(email: String, name: String, password: String, success: (()->Void)?, failure: ((String)->Void)?)
}

class AuthViewModel {
    enum AuthType {
        case login, signup
    }
    
    var authType: AuthType
    
    init(authType: AuthType) {
        self.authType = authType
    }
}

extension AuthViewModel: AuthViewModelProtocol {
    func login(email: String, password: String, success: (()->Void)?, failure: ((String)->Void)?) {
        APIManager.shared.login(email: email, password: password, success: {
            success?()
        }, failure: { (error) in
            failure?(error)
        })
    }
    
    func signUp(email: String, name: String, password: String, success: (()->Void)?, failure: ((String)->Void)?) {
        APIManager.shared.signUp(email: email, name: name, password: password, success: {
            success?()
        }, failure: { (error) in
            failure?(error)
        })
    }
}
