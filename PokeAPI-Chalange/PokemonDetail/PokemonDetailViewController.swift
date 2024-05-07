//
//  PokemonDetailViewController.swift
//  PokeAPI-Chalange
//
//  Created by Mc Parch on 7/5/2567 BE.
//  Copyright (c) 2567 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SkeletonUI
import SDWebImage

protocol PokemonDetailDisplayLogic: AnyObject {
    func displayDetail(presentable: PokemonDetail.Presentable)
    func displayError(error: String)
}

class PokemonDetailViewController: UIViewController {
    static let identifier = "PokemonDetailViewController"

    private enum DesignConstant {
        static let statCellSize: CGSize = CGSize(width: 150, height: 60)
        static let itemCellSize: CGSize = CGSize(width: 80, height: 40)
        static let abilityCellSize: CGSize = CGSize(width: 120, height: 50)
        static let cellGap: CGFloat = 8.0
        static let borderWidth: CGFloat = 1.0
        static let cornerRadius: CGFloat = 8.0
        static let borderColor: UIColor = .white
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var baseExpLabel: UILabel!
    @IBOutlet weak var statHeaderLabel: UILabel!
    @IBOutlet weak var heldItemsHeaderLabel: UILabel!
    @IBOutlet weak var abilityHeaderLabel: UILabel!
    @IBOutlet weak var statsCollectionView: UICollectionView!
    @IBOutlet weak var heldItemsCollectionView: UICollectionView!
    @IBOutlet weak var abilitiesCollectionView: UICollectionView!
    
    var interactor: PokemonDetailBusinessLogic?
    var router: (NSObjectProtocol & PokemonDetailRoutingLogic & PokemonDetailDataPassing)?

    var presentable: PokemonDetail.Presentable? {
        didSet {
            self.nameLabel.text = presentable?.name
            self.weightLabel.text = presentable?.weight
            self.heightLabel.text = presentable?.height
            self.baseExpLabel.text = presentable?.baseExp
        }
    }
    
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
        
        self.statsCollectionView.dataSource = self
        self.heldItemsCollectionView.dataSource = self
        self.abilitiesCollectionView.dataSource = self
        
        self.statsCollectionView.delegate = self
        self.heldItemsCollectionView.delegate = self
        self.abilitiesCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareLayout()
        self.showLoading()
        self.interactor?.getPokemonDetail()
    }
    
    private func prepareLayout() {
        self.avatarImageView.layer.borderColor = DesignConstant.borderColor.cgColor
        self.avatarImageView.layer.borderWidth = DesignConstant.borderWidth
        self.avatarImageView.layer.cornerRadius = DesignConstant.cornerRadius
        
        self.statHeaderLabel.text = "Stats"
        self.heldItemsHeaderLabel.text = "Held Items"
        self.abilityHeaderLabel.text = "Abilities"
    }
    
    private func showLoading() {
        
    }
    
    private func stopLoading() {
        
    }
}

extension PokemonDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           switch collectionView {
           case self.statsCollectionView:
               return self.presentable?.stat.count ?? 0
           case self.heldItemsCollectionView:
               return self.presentable?.heldItems?.count ?? 0
           case self.abilitiesCollectionView:
               return self.presentable?.abilities?.count ?? 0
           default:
               return 0
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           switch collectionView {
           case self.statsCollectionView:
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatCollectionViewCell.reuseableId, for: indexPath) as? StatCollectionViewCell,
                     let stat = self.presentable?.stat[indexPath.row] as? PokemonDetail.Presentable.Stat else {
                   return UICollectionViewCell()
               }
               cell.stat = stat
               return cell
           case self.heldItemsCollectionView:
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseableId, for: indexPath) as? ItemCollectionViewCell,
                     let item = self.presentable?.heldItems?[indexPath.row] else {
                   return UICollectionViewCell()
               }
               cell.nameLabel.text = item
               return cell
           case self.abilitiesCollectionView:
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AbilityCollectionViewCell.reuseableId, for: indexPath) as? AbilityCollectionViewCell,
                     let ability = self.presentable?.abilities?[indexPath.row] as? PokemonDetail.Presentable.Ability else {
                   return UICollectionViewCell()
               }
               cell.ability = ability
               return cell
           default:
               return UICollectionViewCell()
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           switch collectionView {
            case self.statsCollectionView:
               return DesignConstant.statCellSize
            case self.heldItemsCollectionView:
               return DesignConstant.itemCellSize
            case self.abilitiesCollectionView:
               return DesignConstant.abilityCellSize
           default:
               return CGSize.zero
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           DesignConstant.cellGap
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           DesignConstant.cellGap
       }
}

extension PokemonDetailViewController: PokemonDetailDisplayLogic {
    func displayDetail(presentable: PokemonDetail.Presentable) {
        //
        self.stopLoading()
        self.presentable = presentable
        self.avatarImageView.sd_setImage(with: presentable.imgUrl) { image, error, cacheType, url in
            //
        }
        self.navigationItem.title = presentable.name
        self.statsCollectionView.reloadData()
        self.heldItemsCollectionView.reloadData()
        self.abilitiesCollectionView.reloadData()

    }
    
    func displayError(error: String) {
        //
        self.stopLoading()
    }
}

class StatCollectionViewCell: UICollectionViewCell {
    static let reuseableId = "statCellId"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    var stat: PokemonDetail.Presentable.Stat? {
        didSet {
            self.nameLabel.text = stat?.name
            self.valueLabel.text = stat?.value
            self.costLabel.text = stat?.cost
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
    
}

class ItemCollectionViewCell: UICollectionViewCell {
    static let reuseableId = "heldItemCellId"
    
    @IBOutlet weak var nameLabel: UILabel!

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
}
class AbilityCollectionViewCell: UICollectionViewCell {
    static let reuseableId = "abilityCellId"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var slotLabel: UILabel!
    
    var ability: PokemonDetail.Presentable.Ability? {
        didSet {
            self.nameLabel.text = ability?.name
            self.slotLabel.text = ability?.slot
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
}
