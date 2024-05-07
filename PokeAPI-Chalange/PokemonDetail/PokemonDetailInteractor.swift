//
//  PokemonDetailInteractor.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 7/5/2567 BE.
//  Copyright (c) 2567 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PokemonDetailBusinessLogic {
    func getPokemonDetail()
}

protocol PokemonDetailDataStore {
    var pokemonName: String? { get set }
}

class PokemonDetailInteractor: PokemonDetailBusinessLogic, PokemonDetailDataStore {
    var presenter: PokemonDetailPresentationLogic?
    var worker: PokemonDetailWorker?
    var pokemonName: String?
    
    func getPokemonDetail() {
        if let name = pokemonName {
            worker = PokemonDetailWorker()
            worker?.fetchPokemonDetail(name: name) { [weak self] result in
                debugPrint(result)
                switch result {
                case let .success(response):
                    self?.presenter?.presentPokemonDetail(response:response)
                case let .failure(error):
                    self?.presenter?.presentError(error: error.localizedDescription)
                    
                }
            }
        } else {
            presenter?.presentError(error: "No Selected Pokemon")
        }
    }
}
