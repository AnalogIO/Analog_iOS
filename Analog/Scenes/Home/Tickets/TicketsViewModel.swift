//
//  TicketsViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client
import Views

protocol TicketsViewModelDelegate: class {
    func didSetFetchTicketsState(state: State<[TicketCellConfig]>)
}

class TicketsViewModel {
    private var tickets: [Ticket] = []
    public weak var delegate: TicketsViewModelDelegate?

    private var fetchTicketsState: State<[TicketCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchTicketsState(state: fetchTicketsState)
        }
    }

    public func viewWillAppear() {
        fetchTickets()
    }

    public func didSelectItem(at index: Int) {
        let ticket = tickets[index]
        print(ticket)
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
