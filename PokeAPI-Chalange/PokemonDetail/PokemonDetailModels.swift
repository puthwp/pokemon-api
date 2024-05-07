//
//  PokemonDetailModels.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 7/5/2567 BE.
//  Copyright (c) 2567 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum PokemonDetail {
    typealias R = PokemonDetail.Response
    typealias P = PokemonDetail.Presentable
    
    struct Response: Codable {
        
        let name: String
        let order: Int
        let baseExp: Int
        let abilities: [R.Ability]
        let height: Int
        let weight: Int
        let heldItems: [R.HeldItem]?
        let stats: R.Stats
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case order = "order"
            case baseExp = "base_experience"
            case abilities = "abilities"
            case height = "height"
            case weight = "weight"
            case heldItems = "held_items"
            case stats = "stats"
        }
        struct Ability: Codable {
            let name: String
            let slot: Int
            let url: String
            
            enum CodingKeys: String, CodingKey {
                case name = "ability.name"
                case url = "ability.url"
                case slot = "slot"
            }
        }
        
        struct HeldItem: Codable {
            let name: String
            let url: String
            
            enum CodingKeys: String, CodingKey {
                case name = "item.name"
                case url = "item.url"
            }
        }
        
        struct Stats: Codable {
            let name: String
            let value: Int
            let cost: Int
            
            enum CodingKeys: String, CodingKey {
                case name = "stat.name"
                case value = "base_stat"
                case cost = "effort"
            }
        }
    }
    
    struct Presentable {
        let order: Int
        let name: String
        let baseExp: Int
        let abilities: [R.Ability]?
        let height: Int
        let weight: Int
        let heldItems: [R.HeldItem]?
        let stat: [P.Stat]
        
        struct Stat {
            let name: String
            let value: Int
            let cost: Int
        }
    }
}
