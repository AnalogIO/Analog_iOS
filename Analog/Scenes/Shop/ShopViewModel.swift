//
//  ShopViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client
import Views

protocol ShopViewModelDelegate: class {
    func didSetFetchProductsState(state: State<[ProductCellConfig]>)
}

class ShopViewModel {
    private var products: [Product] = []
    public weak var delegate: ShopViewModelDelegate?

    private var fetchProductsState: State<[ProductCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchProductsState(state: fetchProductsState)
        }
    }

    public func viewWillAppear() {
        fetchProducts()
    }

    public func didSelectItem(at index: Int) {
        let purchase = products[index]
        print(purchase)
    }

    private func fetchProducts() {
        fetchProductsState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        Product.getAll().response(using: api, method: .get) { response in
            switch response {
            case .success(let products):
                self.products = products
                let configs = products.map { ProductCellConfig(name: $0.name) }
                self.fetchProductsState = .loaded(configs)
            case .error(let error):
                self.fetchProductsState = .error(error)
            }
        }
    }
}
