//
//  AuthViewController.swift
//  CharOccurence
//
//  Created by Mac on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var repeatPasswordView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var showRepeatPasswordButton: UIButton!
    
    // MARK: - Variables
    var viewModel: AuthViewModel?
    var showPwd: Bool = false {
        didSet {
            showPasswordButton.setTitle(showPwd ? "Hide" : "Show", for: .normal)
            showRepeatPasswordButton.setTitle(showPwd ? "Hide" : "Show", for: .normal)
            
            passwordTextField.isSecureTextEntry = !showPwd
            repeatPasswordTextField.isSecureTextEntry = !showPwd
        }
    }
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        addKeyboardObserver()
        addTapGestureRecognizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
        removeKeyboardObserver()
    }
    
    // MARK: - Functions
    private func setupView() {
        addKeyboardObserver()
        navigationController?.navigationBar.isHidden = false
        
        guard let vm = viewModel else { return }
        
        self.navigationItem.title = vm.authType == .login ? "Login" : "Sign Up"
        
        nameView.isHidden = vm.authType == .login
        repeatPasswordView.isHidden = vm.authType == .login
        
        emailTextField.tag = 1
        
        nameTextField.tag = vm.authType == .login ? 0 : 2
        
        passwordTextField.tag = vm.authType == .login ? 2 : 3
        passwordTextField.returnKeyType = vm.authType == .login ? .done : .next
        
        repeatPasswordTextField.tag = vm.authType == .login ? 0 : 4
    }
    
    private func checkAllFields() -> Bool {
        guard let vm = viewModel else { return false }
        
        if (vm.authType == .login) && (emailTextField.text != nil && passwordTextField.text != nil) {
            return true
        } else if (vm.authType == .signup) && (emailTextField.text != nil && passwordTextField.text != nil && nameTextField.text != nil && repeatPasswordTextField.text != nil) {
            return true
        }
        
        return false
    }
    
    // MARK: - IBActions
    @IBAction func onShowPasswordTapped(_ sender: UIButton) {
        showPwd.toggle()
    }
    
    @IBAction func onSubmitTapped(_ sender: UIButton) {
        if checkAllFields() {
            guard let vm = viewModel else { return }
            
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            if vm.authType == .login {
                viewModel?.login(email: email, password: password, success: {
                    self.performSegue(withIdentifier: Segues.ToMain, sender: self)
                }, failure: { (error) in
                    
                })
            } else {
                guard let name = nameTextField.text else { return }
                
                if passwordTextField.text == repeatPasswordTextField.text {
                    viewModel?.signUp(email: email, name: name, password: password, success: {
                        self.performSegue(withIdentifier: Segues.ToMain, sender: self)
                    }, failure: { (error) in
                        
                    })
                } else {
                    print("action about passwords mismatch")
                }
            }
        }
    }
}

// MARK: Keyboard appear/disappear handler extension
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}

extension AuthViewController {
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        print("keyboard shown")
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        
        print("keyboard hide")
    }
}
