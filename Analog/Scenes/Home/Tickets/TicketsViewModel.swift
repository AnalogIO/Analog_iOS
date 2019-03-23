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
    func didSetFetchTicketsState(state: State<[TicketCellConfig]>)
    func didSetFetchOrderIdState(state: State<MPOrder>)
}

class TicketsViewModel {
    private var tickets: [Ticket] = []
    public weak var delegate: TicketsViewModelDelegate?

    private var fetchTicketsState: State<[TicketCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchTicketsState(state: fetchTicketsState)
        }
    }

    private var fetchOrderIdState: State<MPOrder> = .unknown {
        didSet {
            delegate?.didSetFetchOrderIdState(state: fetchOrderIdState)
        }
    }

    public func viewWillAppear() {
        fetchTickets()
    }

    public func didSelectItem(at index: Int) {
        let ticket = tickets[index]
        print(ticket)
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

    private func fetchTickets() {
        fetchTicketsState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        Ticket.getAll().response(using: api, method: .get) { response in
            switch response {
            case .success(let tickets):
                self.tickets = tickets
                let configs = tickets.map { TicketCellConfig(name: $0.productName) }
                self.fetchTicketsState = .loaded(configs)
            case .error(let error):
                self.fetchTicketsState = .error(error)
            }
        }
    }
}
