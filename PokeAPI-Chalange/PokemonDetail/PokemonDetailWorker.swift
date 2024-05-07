//
//  PokemonDetailWorker.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 7/5/2567 BE.
//  Copyright (c) 2567 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailWorker {
    func fetchPokemonDetail(name: String, onComplete: @escaping (Result<PokemonDetail.Response, AFError>) -> Void) {
        AF.request(Endpoint.detail(name).url, method: .get)
            .responseDecodable(of: PokemonDetail.Response.self) { response in
                debugPrint(response)
                onComplete(response.result)
            }
    }
}
