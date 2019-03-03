//
//  ShopViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

class ShopViewController: UIViewController {

    let collectionView = Views.collectionView()

    let viewModel: ShopViewModel

    var productConfigs: [ProductCellConfig] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: ShopViewModel) {
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
        title = "Shop"
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTargets() {}
}

extension ShopViewController: ShopViewModelDelegate {
    func didSetFetchOrderIdState(state: State<MPOrder>) {
        switch state {
        case .loaded(let order):
            indicator.stop()
            print(order.orderId)
        case .loading:
            indicator.start()
        case .error(let error):
            indicator.stop()
            displayMessage(title: "Missing application", message: error.localizedDescription, actions: [.Ok])
        default:
            break
        }
    }

    func didSetFetchProductsState(state: State<[ProductCellConfig]>) {
        switch state {
        case .loaded(let configs):
            indicator.stop()
            self.productConfigs = configs
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

extension ShopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

extension ShopViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productConfigs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        let config = productConfigs[indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

extension ShopViewController: UICollectionViewDelegateFlowLayout {
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
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        return collectionView
    }
}
