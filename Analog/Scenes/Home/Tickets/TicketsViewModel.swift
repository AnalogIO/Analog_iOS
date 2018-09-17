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

protocol TicketsViewModelDelegate: class {
    func didSetFetchTicketsState(state: State<[Ticket]>)
}

class TicketsViewModel {
    weak var delegate: TicketsViewModelDelegate?

    var fetchTicketsState: State<[Ticket]> = .unknown {
        didSet {
            delegate?.didSetFetchTicketsState(state: fetchTicketsState)
        }
    }

    func viewDidLoad() {
        fetchTickets()
    }

    func fetchTickets() {
        fetchTicketsState = .loading
        let api = ClipCardAPI()
        
    }
}
