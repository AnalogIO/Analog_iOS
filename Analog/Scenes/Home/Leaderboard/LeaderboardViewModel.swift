//
//  LeaderboardViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client

protocol LeaderboardViewModelDelegate: class {
    func didSetFetchLeaderboardState(state: State<[LeaderboardTableViewCellConfig]>)
}

class LeaderboardViewModel {
    weak var delegate: LeaderboardViewModelDelegate?

    private var fetchLeaderboardState: State<[LeaderboardTableViewCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchLeaderboardState(state: fetchLeaderboardState)
        }
    }

    public func viewWillAppear() {
        fetchLeaderboard()
    }

    private func fetchLeaderboard() {
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        Leaderboard.get(type: .all).response(using: api, method: .get) { response in
            switch response {
            case .success(let users):
                let cellConfigs: [LeaderboardTableViewCellConfig] = users.map { LeaderboardTableViewCellConfig(name: $0.name, score: $0.score) }
                self.fetchLeaderboardState = .loaded(cellConfigs)
            case .error(let error):
                self.fetchLeaderboardState = .error(error)
            }
        }
    }
}
