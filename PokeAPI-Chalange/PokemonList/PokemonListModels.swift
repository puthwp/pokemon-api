//
//  PokemonListModels.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 6/5/2567 BE.
//  Copyright (c) 2567 BE Puthiwat Parch. All rights reserved.
//

import UIKit


enum PokemonList {
    struct Response: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let result: [Pokemon]?
        
        enum CodingKeys: String, CodingKey {
            case count, next, previous, result
        }
    }
    
    struct Pokemon: Codable {
        let name: String
        let url: String
        
        static func pokemonIndex(_ input: Pokemon) -> String {
            return String(input.url.dropLast()).components(separatedBy: "/").last ?? ""
        }
    }
    
    struct Presentable {
        let id: String
        let name: String
        let link: URL?
        let imgUrl: URL?
        
        init(_ input: Pokemon) {
            let pokemonId = Pokemon.pokemonIndex(input)
            self.id = pokemonId
            self.name = input.name
            self.link = URL(string: input.url)
            self.imgUrl = URL(string: String(format: Endpoint.imgBaseUrl, pokemonId))
        }
    }
}
