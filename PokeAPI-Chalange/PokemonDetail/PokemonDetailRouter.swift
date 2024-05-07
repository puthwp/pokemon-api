//
//  PokemonDetailRouter.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 7/5/2567 BE.
//  Copyright (c) 2567 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol PokemonDetailRoutingLogic {}

protocol PokemonDetailDataPassing {
    var dataStore: PokemonDetailDataStore? { get }
}

class PokemonDetailRouter: NSObject, PokemonDetailRoutingLogic, PokemonDetailDataPassing {
    weak var viewController: PokemonDetailViewController?
    var dataStore: PokemonDetailDataStore?
}
