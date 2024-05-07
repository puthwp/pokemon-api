//
//  StringExtension.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 8/5/2567 BE.
//

import Foundation
extension Int {
    var toString: String {
        String(format: "%d",self)
    }
    
    var toFormatString: String {
        let formatter = NumberFormatter()
        formatter.groupingSize = 3
        formatter.groupingSeparator = ""
        guard let formated = formatter.string(from: NSNumber(value: self)) else {
            return String(format: "%d", self)
        }
        return formated
    }
}


