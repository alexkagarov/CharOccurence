//
//  APIManager.swift
//  CharOccurence
//
//  Created by Mac on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: NSObject {
    private var user: UserModel?
    
    private var token: String {
        if let token = UserDefaults.standard.string(forKey: UDKeys.Token) {
            return token
        } else if let user = user, let token = user.accessToken {
            return token
        } else {
            return ""
        }
    }
    
    private override init() {
        
    }
    
    static let shared = APIManager()
    
    private func sendRequest(url: String, method: Alamofire.HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, success: ((Data)->Void)?, failure: ((AFError)->Void)?) {
            
        guard let correctedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        var headers = HTTPHeaders()
        
        if token != "" {
            headers = ["Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer \(token)"]
        } else {
            headers = ["Content-Type": "application/json", "Accept": "application/json"]
        }
        
        
        print("*** REQUEST: \(correctedURLString)")
        Alamofire.Session.default.session.configuration.httpCookieStorage = HTTPCookieStorage.shared
        
        Alamofire.Session.default.session.configuration.timeoutIntervalForRequest = 60
        
        Alamofire.Session.default.request(correctedURLString, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (responseData) in
            switch responseData.result {
            case .success(let anyResponse):
                
                if let value = responseData.metrics?.taskInterval.duration {
                    let fvalue = Float(value)
                    let roundedValue = roundf(fvalue * 100) / 100
                    print("\(String(describing: responseData.request?.url)) : \(roundedValue) sec")
                }
                
                print(anyResponse)
                
                if let data = responseData.data {
                    success?(data)
                }
            case .failure(let error):
                
                print("!!!!!!!!!!!!!!!!!!!!")
                print("~ ERROR \(responseData.response?.statusCode ?? 0): " + "\(String(describing: responseData.request?.url))")
                print("!!!!!!!!!!!!!!!!!!!!")
                failure?(error)
            }
        }
    }
}

extension APIManager {
    func checkApiKey() -> Bool {
        if token != "" {
            return true
        }
        
        return false
    }
}

extension APIManager {
    private func cancelAllTasks() {
        Alamofire.Session.default.session.getAllTasks(completionHandler: { (tasks) in
            tasks.forEach({ $0.cancel() })
        })
    }
}

extension APIManager {
    func signUp(email: String, name: String, password: String, success: (()->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + URLs.SignUp
        
        let parameters = ["email": email, "name": name, "password": password]
        
        sendRequest(url: url, method: .post, parameters: parameters, encoding: URLEncoding.default, success: { (data) in
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(UserResponseModel.self, from: data)
                
                if let user = response.data {
                    self.user = user
                    
                    success?()
                } else {
                    self.cancelAllTasks()
                    if let errors = response.errors {
                        let errorsString = errors.compactMap({ $0.message }).joined(separator: "; ")
                        print(errorsString)
                        
                        failure?(errorsString)
                    } else {
                        failure?("Unknown error!!!")
                    }
                }
                
            } catch let error {
                print(error)
                self.cancelAllTasks()
                failure?(error.localizedDescription)
            }
            
        }, failure: { (error) in
            self.cancelAllTasks()
            failure?(error.localizedDescription)
        })
    }
    
    func login(email: String, password: String, success: (()->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + URLs.Login
        
        let parameters = ["email": email, "password": password]
        
        sendRequest(url: url, method: .post, parameters: parameters, encoding: URLEncoding.default, success: { (data) in
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(UserResponseModel.self, from: data)
                
                if let user = response.data {
                    self.user = user
                    
                    if let token = user.accessToken {
                        UserDefaults.standard.set(token, forKey: UDKeys.Token)
                    }
                    
                    success?()
                } else {
                    self.cancelAllTasks()
                    if let errors = response.errors {
                        let errorsString = errors.compactMap({ $0.message }).joined(separator: "; ")
                        print(errorsString)
                        
                        failure?(errorsString)
                    } else {
                        failure?("Unknown error!!!")
                    }
                }
                
            } catch let error {
                print(error)
                self.cancelAllTasks()
                failure?(error.localizedDescription)
            }
            
        }, failure: { (error) in
            self.cancelAllTasks()
            failure?(error.localizedDescription)
        })
    }
    
    func logOut(success: (()->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + URLs.Logout
        
        sendRequest(url: url, method: .post, parameters: nil, encoding: URLEncoding.default, success: { (data) in
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(TextResponseModel.self, from: data)
                
                if let _ = response.data {
                    self.user = nil
                    UserDefaults.standard.set("", forKey: UDKeys.Token)
                    
                    success?()
                } else {
                    self.cancelAllTasks()
                    if let errors = response.errors {
                        let errorsString = errors.compactMap({ $0.message }).joined(separator: "; ")
                        print(errorsString)
                        
                        failure?(errorsString)
                    } else {
                        failure?("Unknown error!!!")
                    }
                }
                
            } catch let error {
                print(error)
                self.cancelAllTasks()
                failure?(error.localizedDescription)
            }
            
        }, failure: { (error) in
            self.cancelAllTasks()
            failure?(error.localizedDescription)
        })
    }
}

extension APIManager {
    func getText(locale: String, success: ((String)->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + URLs.GetText
        
        let parameters = ["Locale": locale]
        
        sendRequest(url: url, method: .get, parameters: parameters, encoding: URLEncoding.default, success: { (data) in
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(TextResponseModel.self, from: data)
                
                if let text = response.data {
                    success?(text)
                } else {
                    self.cancelAllTasks()
                    if let errors = response.errors {
                        let errorsString = errors.compactMap({ $0.message }).joined(separator: "; ")
                        print(errorsString)
                        
                        failure?(errorsString)
                    } else {
                        failure?("Unknown error!!!")
                    }
                }
                
            } catch let error {
                print(error)
                self.cancelAllTasks()
                failure?(error.localizedDescription)
            }
            
        }, failure: { (error) in
            self.cancelAllTasks()
            failure?(error.localizedDescription)
        })
    }
}
