//
//  PokemonDetailPresenter.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 7/5/2567 BE.
//  Copyright (c) 2567 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PokemonDetailPresentationLogic {
    func presentPokemonDetail(response: PokemonDetail.Response)
    func presentError(error: String)
}

class PokemonDetailPresenter: PokemonDetailPresentationLogic {
    weak var viewController: PokemonDetailDisplayLogic?
    
    func presentPokemonDetail(response: PokemonDetail.Response) {
        let presentable = PokemonDetail.Presentable(response)
        viewController?.displayDetail(presentable: presentable)
    }
    
    func presentError(error: String) {
        //
        viewController?.displayError(error: "Cannot load content now")
    }
}
