//
//  PokemonListInteractor.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 6/5/2567 BE.
//  Copyright (c) 2567 BE Puthiwat Parch. All rights reserved.
//

import UIKit

protocol PokemonListBusinessLogic {
    func getPokemonList(limit: Int, offset: Int)
    func searchPokemonName(name: String)
    func selectPokemon(_ item: PokemonList.Presentable)
}

protocol PokemonListDataStore {
    var selectedPokemon: PokemonList.Presentable? { get set }
}

class PokemonListInteractor: PokemonListBusinessLogic, PokemonListDataStore {
    var presenter: PokemonListPresentationLogic?
    var worker: PokemonListWorker?
    var selectedPokemon: PokemonList.Presentable?
    
    func getPokemonList(limit: Int, offset: Int) {
        worker = PokemonListWorker()
        worker?.fetchList(limit: limit, offset: offset) { [weak self] result in
            switch result {
            case let .success(response):
                self?.presenter?.presentList(list: response.result)
            case let .failure(error):
                self?.presenter?.presentError()
            }
        }
    }
    
    func searchPokemonName(name: String) {
        worker?.fetchAllPokemon { [weak self] result in
            switch result {
            case let .success(response):
                self?.filterByName(input: name, list: response.result)
            case let .failure(error):
                self?.presenter?.presentError()
            }
        }
    }
    
    private func filterByName(input: String, list: [PokemonList.Pokemon]?) {
        let foundItem = list?.filter { $0.name.contains(input.lowercased()) }
        presenter?.presentResult(result: foundItem)
    }
    
    func selectPokemon(_ item: PokemonList.Presentable) {
        self.selectedPokemon = item
    }
}
