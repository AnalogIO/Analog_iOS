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
import MobilePayAPI

protocol ShopViewModelDelegate: class {
    func didSetFetchProductsState(state: State<[ProductCellConfig]>)
    func didSetFetchOrderIdState(state: State<MPOrder>)
}

class ShopViewModel {
    private var products: [Product] = []
    public weak var delegate: ShopViewModelDelegate?

    private var fetchProductsState: State<[ProductCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchProductsState(state: fetchProductsState)
        }
    }

    private var fetchOrderIdState: State<MPOrder> = .unknown {
        didSet {
            delegate?.didSetFetchOrderIdState(state: fetchOrderIdState)
        }
    }

    public func viewWillAppear() {
        fetchProducts()
    }

    public func didSelectItem(at index: Int) {
        let product = products[index]
        initiatePurchase(product: product)
    }

    private func initiatePurchase(product: Product) {
        fetchOrderId(productId: product.id, completion: { response in
            switch response {
            case .success(let order):
                let payment: MobilePayPayment = MobilePayPayment(orderId: "\(order.orderId)", productPrice: Float(product.price))
                MobilePayManager.sharedInstance().beginMobilePayment(with: payment, error: {
                    self.fetchOrderIdState = .error($0)
                    return
                })
                self.fetchOrderIdState = .loaded(order)
            case .error(let error):
                self.fetchOrderIdState = .error(error)
            }
        })
    }

    private func fetchOrderId(productId: Int, completion: @escaping ((Response<MPOrder, ClipCardError>) -> Void)) {
        fetchOrderIdState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        let parameters = ["productId": productId]
        MobilePay.initiatePurchase().response(using: api, method: .post, parameters: parameters, response: completion)
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
