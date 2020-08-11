//
//  WelcomeViewController.swift
//  CharOccurence
//
//  Created by Mac on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Variables
    var isLogin: Bool = false
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAuthType {
            guard let dest = segue.destination as? AuthViewController else { return }
            
            let vm = AuthViewModel(authType: isLogin ? .login : .signup)
            dest.viewModel = vm
        }
    }
    
    // MARK: - IBActions
    @IBAction func onAuthMethodTapped(_ sender: UIButton) {
        isLogin = sender.tag == 0
        performSegue(withIdentifier: Segues.ToAuthType, sender: self)
    }
}
