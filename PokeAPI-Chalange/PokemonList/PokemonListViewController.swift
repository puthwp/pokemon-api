//
//  PokemonListViewController.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 6/5/2567 BE.
//  Copyright (c) 2567 BE Puthiwat Parch. All rights reserved.
//

import UIKit
import SkeletonUI
import SDWebImage

protocol PokemonListDisplayLogic: AnyObject {
    func displayList(_ list: [PokemonList.Presentable]?)
    func displayError()
}

class PokemonListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var pokemons: [PokemonList.Presentable]?
    let limitItem: Int = 20
    var offsetItem: Int = 0

    var interactor: PokemonListBusinessLogic?
    var router: (NSObjectProtocol & PokemonListRoutingLogic & PokemonListDataPassing)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = PokemonListInteractor()
        let presenter = PokemonListPresenter()
        let router = PokemonListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pokemons?.count == 0 {
            interactor?.getPokemonList(limit: limitItem, offset: offsetItem)
        }
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonItemCell.reuseableId, for: indexPath) as? PokemonItemCell,
              let indexPokemon = pokemons?[indexPath.row] as? PokemonList.Presentable else {
            return UICollectionViewCell()
        }
        cell.pokemon = indexPokemon
        return cell
    }
    
    
}

extension PokemonListViewController: PokemonListDisplayLogic {
    func displayList(_ list: [PokemonList.Presentable]?){
        self.pokemons = list
        self.collectionView.reloadData()
    }
    
    func displayError() {
        //do something
    }
}


class PokemonItemCell: UICollectionViewCell {
    static let reuseableId = "pokemonItemCell"
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var pokemon: PokemonList.Presentable? {
        didSet {
            self.nameLabel.text = pokemon?.name
            self.imageview.sd_setImage(with: pokemon?.imgUrl) { image, error, cacheType, url in
                //
            }
        }
    }
    override func prepareForReuse() {
        self.imageview.image = nil
        self.nameLabel.text = ""
    }
}
