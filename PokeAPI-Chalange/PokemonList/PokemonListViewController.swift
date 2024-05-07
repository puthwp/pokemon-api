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
    func displayResult(_ result: [PokemonList.Presentable]?)
    func displayError()
}

class PokemonListViewController: UIViewController {
    
    enum DesignConstant {
        static let cellGap: CGFloat = 8.0
    }
    
    enum DisplayType {
        case feeds
        case search
    }
    
    @IBOutlet var collectionView: UICollectionView!
    var pokemons: [PokemonList.Presentable] = []
    var resultPokemons: [PokemonList.Presentable]?
    let limitItem: Int = 20
    var offsetItem: Int = 0
    var searchDelay: DispatchWorkItem?
    var searchingName: String?
    
    var currentDisplayType: DisplayType = .feeds
    
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
        if pokemons.count == 0 {
            interactor?.getPokemonList(limit: limitItem, offset: offsetItem)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentDisplayType {
        case .feeds:
            return self.pokemons.count
        case .search:
            return self.resultPokemons?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonItemCell.reuseableId, for: indexPath) as? PokemonItemCell else {
            return UICollectionViewCell()
        }
        
        switch currentDisplayType {
        case .feeds:
            cell.pokemon = self.pokemons[indexPath.row]
        case .search:
            if let pokemon = self.resultPokemons?[indexPath.row] as? PokemonList.Presentable {
                cell.pokemon = pokemon
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfScreen = (UIScreen.main.bounds.width - (DesignConstant.cellGap * 2)) / 2
        return CGSize(width: halfScreen, height: halfScreen)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        DesignConstant.cellGap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        DesignConstant.cellGap
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PokemonSearchBarReuseableView.reuseableId, for: indexPath) as? PokemonSearchBarReuseableView else {
                return UICollectionReusableView()
            }
            guard header.searchBar.delegate is PokemonListViewController else {
                return header
            }
            header.searchBar.delegate = self
            return header
        default:
            assert(false, "no collect type view")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentDisplayType {
        case .feeds:
            let pokemon = self.pokemons[indexPath.row]
            self.interactor?.selectPokemon(pokemon)
        case .search:
            if let pokemon = self.resultPokemons?[indexPath.row] as? PokemonList.Presentable {
                self.interactor?.selectPokemon(pokemon)
            }
        }
        self.router?.routeToDetailView()
    }
}

extension PokemonListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.currentDisplayType == .feeds else {
            return
        }
        if checkBottomScroll(scrollView) {
            interactor?.getPokemonList(limit: limitItem, offset: pokemons.count)
        }
    }
    
    private func checkBottomScroll(_ scrollView: UIScrollView) -> Bool {
        scrollView.contentOffset.y > scrollView.contentSize.height - (self.view.bounds.height * 1.3)
    }
}

extension PokemonListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Text did changed
        guard searchText.contains(/[a-zA-Z]+/) else {
            self.currentDisplayType = .feeds
//            self.searchingName = ""
            self.collectionView.reloadData()
            return
        }
        self.currentDisplayType = .search
        self.searchingName = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchDelay?.cancel()
        searchDelay = DispatchWorkItem { [weak self] in
            self?.interactor?.searchPokemonName(name: self?.searchingName ?? "")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: searchDelay!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.currentDisplayType = .feeds
        self.collectionView.reloadData()
    }
}

extension PokemonListViewController: PokemonListDisplayLogic {
    func displayList(_ list: [PokemonList.Presentable]?){
        if let newItem = list {
            self.pokemons.append(contentsOf: newItem)
            self.collectionView.reloadData()
        }
    }
    
    func displayResult(_ result: [PokemonList.Presentable]?) {
        if let resultItems = result {
            self.resultPokemons = resultItems
            self.collectionView.reloadData()
        }
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
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
    }
    override func prepareForReuse() {
        self.imageview.image = nil
        self.nameLabel.text = ""
    }
}

class PokemonSearchBarReuseableView: UICollectionReusableView {
    static let reuseableId = "pokemonSearchBarView"
    
    @IBOutlet weak var searchBar: UISearchBar!
}
