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
    
    struct Response: Decodable {
        let id: Int
        let name: String
        let order: Int
        let baseExp: Int
        let abilities: [R.Ability]
        let height: Int
        let weight: Int
        let heldItems: [R.HeldItem]?
        let stats: [R.Stats]
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case order = "order"
            case baseExp = "base_experience"
            case abilities = "abilities"
            case height = "height"
            case weight = "weight"
            case heldItems = "held_items"
            case stats = "stats"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<R.CodingKeys> = try decoder.container(keyedBy: R.CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.order = try container.decode(Int.self, forKey: .order)
            self.baseExp = try container.decode(Int.self, forKey: .baseExp)
            self.abilities = try container.decode([R.Ability].self, forKey: .abilities)
            self.height = try container.decode(Int.self, forKey: .height)
            self.weight = try container.decode(Int.self, forKey: .weight)
            self.heldItems = try container.decode([R.HeldItem].self, forKey: .heldItems)
            self.stats = try container.decode([R.Stats].self, forKey: .stats)
        }
        struct Ability: Decodable {
            let name: String
            let slot: Int
            let url: String
            
            enum CodingKeys: String, CodingKey {
                case ability = "ability"
                case slot = "slot"
            }
            
            enum AbilityCodingKeys: String, CodingKey {
                case name = "name"
                case url = "url"
            }
            
            init(from decoder: Decoder) throws {
                let container: KeyedDecodingContainer<R.Ability.CodingKeys> = try decoder.container(keyedBy: R.Ability.CodingKeys.self)
                self.slot = try container.decode(Int.self, forKey: .slot)
                let name = try container.nestedContainer(keyedBy: PokemonDetail.Response.Ability.AbilityCodingKeys.self, forKey: .ability)
                self.name = try name.decode(String.self, forKey: .name)
                self.url = try name.decode(String.self, forKey: .url)
            }
        }
        
        struct HeldItem: Decodable {
            let name: String
            let url: String
            
            enum CodingKeys: String, CodingKey {
                case name = "name"
                case url = "url"
            }
            
            enum ItemCodingKeys: String, CodingKey {
                case item = "item"
            }
            
            init(from decoder: Decoder) throws {
                let container: KeyedDecodingContainer<R.HeldItem.ItemCodingKeys> = try decoder.container(keyedBy: R.HeldItem.ItemCodingKeys.self)
                let item = try container.nestedContainer(keyedBy: R.HeldItem.CodingKeys.self, forKey: .item)
                self.name = try item.decode(String.self, forKey: .name)
                self.url = try item.decode(String.self, forKey: .url)
            }
        }
        
        struct Stats: Decodable {
            let name: String
            let value: Int
            let cost: Int
            
            enum CodingKeys: String, CodingKey {
                case stat = "stat"
                case value = "base_stat"
                case cost = "effort"
            }
            
            enum StatCodingKeys: String, CodingKey {
                case name = "name"
            }
            
            init(from decoder: Decoder) throws {
                let container: KeyedDecodingContainer<R.Stats.CodingKeys> = try decoder.container(keyedBy: R.Stats.CodingKeys.self)
                self.value = try container.decode(Int.self, forKey: .value)
                self.cost = try container.decode(Int.self, forKey: .cost)
                let name = try container.nestedContainer(keyedBy: R.Stats.StatCodingKeys.self, forKey: .stat)
                self.name = try name.decode(String.self, forKey: .name)
            }
        }
    }
    
    struct Presentable {
        let name: String
        let imgUrl: URL?
        let order: String
        let baseExp: String
        let abilities: [P.Ability]?
        let height: String
        let weight: String
        let heldItems: [String]?
        let stat: [P.Stat]
        
        struct Stat {
            let name: String
            let value: String
            let cost: String
            
            init(_ item: R.Stats) {
                self.name = item.name.capitalized
                self.value = String(format: "value: %@", item.value.toFormatString)
                self.cost = String(format: "cost: %@", item.cost.toFormatString)
            }
        }
        
        struct Ability {
            let name: String
            let slot: String
            
            init(_ item: R.Ability) {
                self.name = item.name.capitalized
                self.slot = String(format: "slot: %d", item.slot)
            }
        }
        
        init(_ item: R) {
            self.name = item.name.capitalized
            self.imgUrl = URL(string: String(format: Endpoint.imgBaseUrl, item.id.toString))
            self.order = String(format: "Order: %@", item.order.toFormatString)
            self.baseExp = String(format: "Base EXP: %@", item.baseExp.toFormatString)
            self.abilities = item.abilities.map { P.Ability($0) }
            self.height = String(format: "Height: %@", item.height.toFormatString)
            self.weight = String(format: "Weight: %@", item.weight.toFormatString)
            self.heldItems = item.heldItems?.makeIterator().map { $0.name.replacingOccurrences(of: "-", with: " ").capitalized }
            self.stat = item.stats.map { P.Stat($0) }
        }
    }
}
