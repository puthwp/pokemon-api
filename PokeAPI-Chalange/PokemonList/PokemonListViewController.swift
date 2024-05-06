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
    enum DesignConstant {
        static let cellGap: CGFloat = 8.0
    }
    @IBOutlet var collectionView: UICollectionView!
    var pokemons: [PokemonList.Presentable] = []
    let limitItem: Int = 20
    var offsetItem: Int = 0
    var searchDelay: DispatchWorkItem?
    var searchingName: String?
    
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
        self.collectionView.register(PokemonSearchBarReuseableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PokemonSearchBarReuseableView.reuseableId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pokemons.count == 0 {
            interactor?.getPokemonList(limit: limitItem, offset: offsetItem)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        searchDelay = DispatchWorkItem { [weak self] in
//            self?.interactor?.searchPokemonName(name: self?.searchingName ?? "")
//        }
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonItemCell.reuseableId, for: indexPath) as? PokemonItemCell else {
            return UICollectionViewCell()
        }
        cell.pokemon = pokemons[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfScreen = (UIScreen.main.bounds.width - (DesignConstant.cellGap * 2)) / 2
        return CGSize(width: halfScreen, height: halfScreen)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionFooter else {
//            return UICollectionReusableView()
//        }
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PokemonSearchBarReuseableView.reuseableId, for: indexPath)
//        return header
//    }
    
}

extension PokemonListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if checkBottomScroll(scrollView) {
            interactor?.getPokemonList(limit: limitItem, offset: pokemons.count)
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    private func checkBottomScroll(_ scrollView: UIScrollView) -> Bool {
        scrollView.contentOffset.y > scrollView.contentSize.height - (self.view.bounds.height * 1.3)
    }
}

//extension PokemonListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // Click search bar action
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // Text did changed
//        self.searchingName = searchText
//        searchDelay?.cancel()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: searchDelay!)
//    }
//}

extension PokemonListViewController: PokemonListDisplayLogic {
    func displayList(_ list: [PokemonList.Presentable]?){
        if let newItem = list {
            self.pokemons.append(contentsOf: newItem)
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
