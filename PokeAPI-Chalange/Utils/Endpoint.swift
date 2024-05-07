//
//  ResponseObject.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 6/5/2567 BE.
//

import Foundation

enum Endpoint {
    case pokemon(Int, Int)
    case seach
    case detail(String)
    
    static let  baseUrl: URL = URL(string: Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String)!
    
    
    static let imgBaseUrl: String = Bundle.main.object(forInfoDictionaryKey: "IMG_BASE_URL") as! String
    
    
    var str: String {
        switch self {
        case let .pokemon(offset, limit):
            return String(format: "pokemon?offset=%d&limit=%d", offset,limit)
        case .seach:
            return "pokemon?offset=0&limit=10000"
        case let .detail(name):
            return "pokemon/" + name.lowercased()
        }
    }
    var url: URL {
        URL(string: self.str, relativeTo: Endpoint.baseUrl)!
    }
}
