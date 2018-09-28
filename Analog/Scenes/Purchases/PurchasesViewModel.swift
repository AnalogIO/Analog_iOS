//
//  PurchasesViewModel.swift
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

protocol PurchasesViewModelDelegate: class {
    func didSetFetchPurchasesState(state: State<[PurchaseCellConfig]>)
}

class PurchasesViewModel {
    private var purchases: [Purchase] = []
    public weak var delegate: PurchasesViewModelDelegate?

    private var fetchPurchasesState: State<[PurchaseCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchPurchasesState(state: fetchPurchasesState)
        }
    }

    public func viewDidLoad() {
        fetchPurchases()
    }

    public func didSelectItem(at index: Int) {
        let purchase = purchases[index]
        print(purchase)
    }

    private func fetchPurchases() {
        fetchPurchasesState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        Purchase.getAll().response(using: api, method: .get) { response in
            switch response {
            case .success(let purchases):
                self.purchases = purchases
                let configs = purchases.map { PurchaseCellConfig(name: $0.productName) }
                self.fetchPurchasesState = .loaded(configs)
            case .error(let error):
                self.fetchPurchasesState = .error(error)
            }
        }
    }
}
