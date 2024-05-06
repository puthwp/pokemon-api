//
//  PokemonListPresenter.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 6/5/2567 BE.
//  Copyright (c) 2567 BE Puthiwat Parch. All rights reserved.
//

import UIKit

protocol PokemonListPresentationLogic {
    func presentList(list: [PokemonList.Pokemon]?)
    func presentError()
}

class PokemonListPresenter: PokemonListPresentationLogic {
    weak var viewController: PokemonListDisplayLogic?
    
    func presentList(list: [PokemonList.Pokemon]?) {
        let presentable = list?.makeIterator().map { PokemonList.Presentable($0) }
        viewController?.displayList(presentable)
    }
    
    func presentError() {
        
    }
}
