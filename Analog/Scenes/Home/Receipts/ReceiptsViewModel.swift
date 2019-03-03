//
//  ReceiptsViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client

protocol ReceiptsViewModelDelegate: class {
    func didSetFetchReceiptsState(state: State<[ReceiptCellConfig]>)
}

class ReceiptsViewModel {
    private var receipts: [Ticket] = []
    public weak var delegate: ReceiptsViewModelDelegate?

    private var fetchReceiptsState: State<[ReceiptCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchReceiptsState(state: fetchReceiptsState)
        }
    }

    public func viewWillAppear() {
        fetchReceipts()
    }

    public func didSelectItem(at index: Int) {
        let receipt = receipts[index]
        print(receipt)
    }

    private func fetchReceipts() {
        fetchReceiptsState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        Receipt.getAll().response(using: api, method: .get) { response in
            switch response {
            case .success(let receipts):
                self.receipts = receipts
                let configs = receipts.map { ReceiptCellConfig(name: $0.productName) }
                self.fetchReceiptsState = .loaded(configs)
            case .error(let error):
                self.fetchReceiptsState = .error(error)
            }
        }
    }
}
