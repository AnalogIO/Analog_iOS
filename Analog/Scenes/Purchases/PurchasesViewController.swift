//
//  PurchasesViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class PurchasesViewController: UIViewController {

    let collectionView = Views.collectionView()

    let viewModel: PurchasesViewModel

    var purchaseConfigs: [PurchaseCellConfig] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: PurchasesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Purchases"
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    private func defineLayout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTargets() {}
}

extension PurchasesViewController: PurchasesViewModelDelegate {
    func didSetFetchPurchasesState(state: State<[PurchaseCellConfig]>) {
        switch state {
        case .loaded(let configs):
            indicator.stop()
            self.purchaseConfigs = configs
        case .loading:
            indicator.start()
        case .error(let error):
            indicator.stop()
            print(error.localizedDescription)
        default:
            break
        }
    }
}

extension PurchasesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

extension PurchasesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchaseConfigs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PurchaseCollectionViewCell.reuseIdentifier, for: indexPath) as! PurchaseCollectionViewCell
        let config = purchaseConfigs[indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

extension PurchasesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width-16*2, height: collectionView.bounds.height*0.3)
    }
}

private enum Views {
    static func collectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Color.background
        collectionView.register(PurchaseCollectionViewCell.self, forCellWithReuseIdentifier: PurchaseCollectionViewCell.reuseIdentifier)
        return collectionView
    }
}
