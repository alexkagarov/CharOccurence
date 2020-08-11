//
//  AuthViewModel.swift
//  CharOccurence
//
//  Created by Mac on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

protocol AuthViewModelProtocol {
    func login(success:()?, failure:()?)
    func signUp(success:()?, failure:()?)
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
    func login(success: ()?, failure: ()?) {
        
    }
    
    func signUp(success: ()?, failure: ()?) {
        
    }
}
