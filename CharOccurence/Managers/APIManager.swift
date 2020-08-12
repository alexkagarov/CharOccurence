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
        super.init()
    }
    
    static let shared = APIManager()
    
    private func sendRequest(url: String, method: Alamofire.HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, encoding: ParameterEncoding, success: ((Data)->Void)?, failure: ((AFError)->Void)?) {
            
        guard let correctedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
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
        
        sendRequest(url: url, method: .post, parameters: parameters, headers: nil, encoding: JSONEncoding.default, success: { (data) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let response = try decoder.decode(UserResponseModel.self, from: data)
                
                if response.success {
                    if let user = response.data {
                        self.user = user
                        
                        if let token = user.accessToken {
                            UserDefaults.standard.set(token, forKey: UDKeys.Token)
                        }
                        
                        success?()
                    }
                } else {
                    self.cancelAllTasks()
                    if let errors = response.errors {
                        let errorsString = errors.compactMap({ $0.message }).joined(separator: " ")
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
        
        sendRequest(url: url, method: .post, parameters: parameters, headers: nil, encoding: JSONEncoding.default, success: { (data) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let response = try decoder.decode(UserResponseModel.self, from: data)
                
                if response.success {
                    if let user = response.data {
                        self.user = user
                        
                        if let token = user.accessToken {
                            UserDefaults.standard.set(token, forKey: UDKeys.Token)
                        }
                        
                        success?()
                    }
                } else {
                    self.cancelAllTasks()
                    if let errors = response.errors {
                        let errorsString = errors.compactMap({ $0.message }).joined(separator: " ")
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
    
    func logOut(success: (()->Void)?, failure: ((String)->Void)?) { // API returns error 500 on logout, so I won't logout on server side, though I wanted to
        /*let url = URLs.Server + URLs.Logout
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        sendRequest(url: url, method: .post, parameters: nil, headers: headers, encoding: JSONEncoding.default, success: { (data) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let response = try decoder.decode(TextResponseModel.self, from: data)
                
                if response.success {*/
                    self.user = nil
                    UserDefaults.standard.set("", forKey: UDKeys.Token)
                    
                    success?()
                /*} else {
                    self.cancelAllTasks()
                    if let errors = response.errors {
                        let errorsString = errors.compactMap({ $0.message }).joined(separator: " ")
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
        })*/
    }
}

extension APIManager {
    func getText(locale: String, success: ((String)->Void)?, failure: ((String)->Void)?) {
        let url = URLs.Server + URLs.GetText
        
        let parameters = ["Locale": locale]
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        sendRequest(url: url, method: .get, parameters: parameters, headers: headers, encoding: URLEncoding.default, success: { (data) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let response = try decoder.decode(TextResponseModel.self, from: data)
                
                if response.success {
                    if let text = response.data {
                        success?(text)
                    }
                } else {
                    self.cancelAllTasks()
                    if let errors = response.errors {
                        let errorsString = errors.compactMap({ $0.message }).joined(separator: " ")
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
