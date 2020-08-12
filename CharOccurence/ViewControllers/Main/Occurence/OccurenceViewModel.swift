//
//  OccurenceViewModel.swift
//  CharOccurence
//
//  Created by Mac on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

protocol OccurenceViewModelProtocol {
    var locales: [String] { get }
    
    var selectedLocale: String { get set }
    
    var generatedText: String { get set }
    
    func getText(locale: String, success: (()->Void)?, failure: ((String)->Void)?)
    func logout(success: (()->Void)?, failure: ((String)->Void)?)
}

class OccurenceViewModel: OccurenceViewModelProtocol {
    let locales = [ "bg_BG", "da_DK", "el_GR", "en_NG", "en_ZA", "fi_FI", "he_IL", "ka_GE", "me_ME", "nl_NL", "pt_PT", "sr_Cyrl_RS", "tr_TR", "zh_TW", "ar_JO", "en_AU", "en_NZ", "es_AR", "hr_HR", "kk_KZ", "ro_MD", "sr_Latn_RS", "uk_UA", "ar_SA", "bn_BD", "de_AT", "en_CA", "en_PH", "es_ES", "fr_BE", "is_IS", "ko_KR", "mn_MN", "ro_RO", "sr_RS", "at_AT", "de_CH", "en_GB", "en_SG", "es_PE", "fr_CA", "hu_HU", "it_CH", "nb_NO", "ru_RU", "sv_SE", "de_DE", "en_HK", "en_UG", "es_VE", "fr_CH", "hy_AM", "it_IT", "lt_LT", "ne_NP", "pl_PL", "sk_SK", "vi_VN", "cs_CZ", "el_CY", "en_IN", "en_US", "fa_IR", "fr_FR", "id_ID", "ja_JP", "lv_LV", "nl_BE", "pt_BR", "sl_SI", "th_TH", "zh_CN" ].sorted()
    
    var charsOccurency = [[Character: Int]]()
    
    var selectedLocale: String = ""
    
    var generatedText: String = ""
}

extension OccurenceViewModel {
    func getText(locale: String, success: (()->Void)?, failure: ((String)->Void)?) {
        APIManager.shared.getText(locale: locale, success: { (text) in
            self.generatedText = text
            self.charsOccurency = self.countOccurence(text: text)
            
            success?()
        
        }, failure: { (error) in
            failure?(error)
        })
    }
    
    func countOccurence(text: String) -> [[Character: Int]] {
        var occurency = [Character: Int]()
        
        text.forEach({ (char) in
            if let charCount = occurency[char] {
                occurency[char] = charCount + 1
            } else {
                occurency[char] = 1
            }
        })
        
        return occurency.sorted(by: { $0.key < $1.key }).compactMap({ [$0.key : $0.value] })
    }
    
    func logout(success: (()->Void)?, failure: ((String)->Void)?) {
        APIManager.shared.logOut(success: {
            success?()
        }, failure: { (error) in
            failure?(error)
        })
    }
}
