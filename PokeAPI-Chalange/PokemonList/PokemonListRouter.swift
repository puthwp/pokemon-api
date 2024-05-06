//
//  PokemonListRouter.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 6/5/2567 BE.
//  Copyright (c) 2567 BE Puthiwat Parch. All rights reserved.
//

import UIKit

@objc protocol PokemonListRoutingLogic {}

protocol PokemonListDataPassing {
    var dataStore: PokemonListDataStore? { get }
}

class PokemonListRouter: NSObject, PokemonListRoutingLogic, PokemonListDataPassing {
    weak var viewController: PokemonListViewController?
    var dataStore: PokemonListDataStore?
}
