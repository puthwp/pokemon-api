//
//  PokemonDetailViewController.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 7/5/2567 BE.
//  Copyright (c) 2567 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SkeletonUI

protocol PokemonDetailDisplayLogic: AnyObject {
    func displayDetail(presentable: PokemonDetail.Presentable)
    func displayError(error: String)
}

class PokemonDetailViewController: UIViewController {
    static let identifier = "PokemonDetailViewController"

    var interactor: PokemonDetailBusinessLogic?
    var router: (NSObjectProtocol & PokemonDetailRoutingLogic & PokemonDetailDataPassing)?

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
        let interactor = PokemonDetailInteractor()
        let presenter = PokemonDetailPresenter()
        let router = PokemonDetailRouter()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareLayout()
        self.showLoading()
        self.interactor?.getPokemonDetail()
    }
    
    private func prepareLayout() {
    }
    
    private func showLoading() {
        
    }
    
    private func stopLoading() {
        
    }
}

extension PokemonDetailViewController: PokemonDetailDisplayLogic {
    func displayDetail(presentable: PokemonDetail.Presentable) {
        //
        self.stopLoading()
    }
    
    func displayError(error: String) {
        //
        self.stopLoading()
    }
}
