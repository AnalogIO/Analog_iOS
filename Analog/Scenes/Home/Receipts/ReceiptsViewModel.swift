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
    func showReceipt(receipt: Ticket)
    func didSetFetchPurchasesState(state: State<[PurchaseCellConfig]>)
    func setSelectedSegment(index: Int)
}

class ReceiptsViewModel {
    private var receipts: [Ticket] = []
    private var purchases: [Purchase] = []

    private var selectedIndex: Int? = nil {
        didSet {
            guard let index = selectedIndex else { return }
            delegate?.setSelectedSegment(index: index)
            if index == 0 { fetchReceipts() }
            else { fetchPurchases() }
        }
    }

    public weak var delegate: ReceiptsViewModelDelegate?

    private var fetchReceiptsState: State<[ReceiptCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchReceiptsState(state: fetchReceiptsState)
        }
    }
    private var fetchPurchasesState: State<[PurchaseCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchPurchasesState(state: fetchPurchasesState)
        }
    }

    public func viewWillAppear() {
        selectedIndex = 0
    }

    public func didSelectItem(at index: Int) {
        guard let selectedIndex = selectedIndex else { return }
        if selectedIndex == 0 {
            let receipt = receipts[index]
            delegate?.showReceipt(receipt: receipt)
        } else {
            let purchase = purchases[index]
            print(purchase)
        }
    }

    public func didSelectSegment(index: Int) {
        selectedIndex = index
    }

    private func fetchReceipts() {
        fetchReceiptsState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        Ticket.getAll(used: true).response(using: api, method: .get) { response in
            switch response {
            case .success(let receipts):
                self.receipts = receipts
                let configs: [ReceiptCellConfig] = receipts.map { ReceiptCellConfig(name: $0.productName, date: DateFormat.format($0.dateUsed) ?? "") }
                let sortedConfigs: [ReceiptCellConfig] = configs.sorted { $0.date > $1.date }
                self.fetchReceiptsState = .loaded(sortedConfigs)
            case .error(let error):
                self.fetchReceiptsState = .error(error)
            }
        }
    }

    private func fetchPurchases() {
        fetchPurchasesState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        Purchase.getAll().response(using: api, method: .get) { response in
            switch response {
            case .success(let purchases):
                self.purchases = purchases
                let configs: [PurchaseCellConfig] = purchases.map { PurchaseCellConfig(name: $0.productName, date: DateFormat.format($0.dateCreated) ?? "") }
                let sortedConfigs: [PurchaseCellConfig] = configs.sorted { $0.date > $1.date }
                self.fetchPurchasesState = .loaded(sortedConfigs)
            case .error(let error):
                self.fetchPurchasesState = .error(error)
            }
        }
    }
}
