//
//  PokemonListWorker.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 6/5/2567 BE.
//  Copyright (c) 2567 BE Puthiwat Parch. All rights reserved.
//

import UIKit
import Alamofire

class PokemonListWorker {
    func fetchList(limit: Int, offset: Int,
                   onComplete: @escaping (Result<PokemonList.Response, AFError>) -> Void) {
        AF.request(Endpoint.pokemon(offset, limit).url, method: .get)
            .responseDecodable(of: PokemonList.Response.self) { response in
                debugPrint(response)
                onComplete(response.result)
            }
    }
    
    func fetchAllPokemon(_ onComplete: @escaping (Result<PokemonList.Response, AFError>) -> Void) {
        AF.request(Endpoint.seach.url, method: .get)
            .responseDecodable(of: PokemonList.Response.self) { response in
                debugPrint(response)
                onComplete(response.result)
            }
    }
}
