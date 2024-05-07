//
//  PokemonListRouter.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 6/5/2567 BE.
//  Copyright (c) 2567 BE Puthiwat Parch. All rights reserved.
//

import UIKit

@objc protocol PokemonListRoutingLogic {
    func routeToDetailView()
}

protocol PokemonListDataPassing {
    var dataStore: PokemonListDataStore? { get }
}

class PokemonListRouter: NSObject, PokemonListRoutingLogic, PokemonListDataPassing {
    weak var viewController: PokemonListViewController?
    var dataStore: PokemonListDataStore?
    
    func routeToDetailView() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let name = dataStore?.selectedPokemon?.name,
           let vc = storyboard.instantiateViewController(withIdentifier: PokemonDetailViewController.identifier) as? PokemonDetailViewController {
            let interactor = PokemonDetailInteractor()
            let presenter = PokemonDetailPresenter()
            let router = PokemonDetailRouter()
            interactor.pokemonName = name
            vc.interactor = interactor
            vc.router = router
            interactor.presenter = presenter
            presenter.viewController = vc
            router.viewController = vc
            router.dataStore = interactor
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
