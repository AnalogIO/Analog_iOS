//
//  TicketsViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import MobilePayAPI
import Entities
import Client

protocol TicketsViewModelDelegate: class {
    func didSetFetchCoffeecardsState(state: State<[CoffeecardCellConfig]>)
    func didSetFetchOrderIdState(state: State<MPOrder>)
    func didSetUseTicketState(state: State<Ticket>)
    func index(for cell: CoffeecardCollectionViewCell) -> Int?
    func showSwipeButton(animated: Bool)
    func hideSwipeButton(animated: Bool)
    func reloadData()
    func resetSwipeButton()
    func showReceipt(receipt: Ticket)
}

class TicketsViewModel {
    private var coffeecards: [Coffeecard] = [] {
        didSet {
            coffeecards.sort { $0.ticketsLeft > $1.ticketsLeft }
        }
    }
    public weak var delegate: TicketsViewModelDelegate?

    private var fetchCoffeecardsState: State<[CoffeecardCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchCoffeecardsState(state: fetchCoffeecardsState)
        }
    }

    private var fetchOrderIdState: State<MPOrder> = .unknown {
        didSet {
            delegate?.didSetFetchOrderIdState(state: fetchOrderIdState)
        }
    }

    private var useTicketState: State<Ticket> = .unknown {
        didSet {
            delegate?.didSetUseTicketState(state: useTicketState)
        }
    }

    private var selectedIndex: Int? = nil {
        didSet {
            if selectedIndex == nil {
                delegate?.hideSwipeButton(animated: true)
            } else {
                delegate?.showSwipeButton(animated: true)
            }
            delegate?.reloadData()
        }
    }

    private var selectedCoffeecard: Coffeecard? {
        if let index = selectedIndex, coffeecards.count > index {
            return coffeecards[index]
        } else {
            return nil
        }
    }

    public func viewWillAppear() {
        fetchTickets()
    }

    public func viewDidDisappear() {
        selectedIndex = nil
    }

    public func didSwipe() {
        guard let coffeecard = selectedCoffeecard else { return }
        useTicket(productId: coffeecard.productId)
    }

    public func didPressShop(in cell: CoffeecardCollectionViewCell) {
        guard let index = delegate?.index(for: cell) else { return }
        let coffeecard = coffeecards[index]
        initiatePurchase(coffeecard: coffeecard)
    }

    public func didPressSelect(in cell: CoffeecardCollectionViewCell) {
        selectedIndex = delegate?.index(for: cell)
    }

    public func isCellSelected(index: Int) -> Bool {
        return index == selectedIndex
    }

    private func useTicket(productId: Int) {
        useTicketState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        let parameters = ["productId": productId]
        Ticket.use().response(using: api, method: .post, parameters: parameters) { response in
            self.delegate?.resetSwipeButton()
            self.selectedIndex = nil
            switch response {
            case .success(let ticket):
                self.useTicketState = .loaded(ticket)
                self.fetchTickets()
            case .error(let error):
                self.useTicketState = .error(error)
            }
        }
    }

    private func initiatePurchase(coffeecard: Coffeecard) {
        fetchOrderId(productId: coffeecard.productId, completion: { response in
            switch response {
            case .success(let order):
                let payment: MobilePayPayment = MobilePayPayment(orderId: "\(order.orderId)", productPrice: Float(coffeecard.price))
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

    func fetchTickets() {
        fetchCoffeecardsState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        Coffeecard.getAll().response(using: api, method: .get) { response in
            switch response {
            case .success(let coffeecards):
                self.coffeecards = coffeecards
                let configs = self.coffeecards.map { CoffeecardCellConfig(name: $0.name, ticketsLeft: $0.ticketsLeft, didPressShop: self.didPressShop, didPressSelect: self.didPressSelect) }
                self.fetchCoffeecardsState = .loaded(configs)
            case .error(let error):
                self.fetchCoffeecardsState = .error(error)
            }
        }
    }
}
