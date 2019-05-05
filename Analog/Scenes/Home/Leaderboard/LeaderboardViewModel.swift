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
    func didSetFetchLeaderboardState(state: State<[LeaderboardCollectionViewCellConfig]>)
}

class LeaderboardViewModel {
    var users: [LeaderboardUser] = [] {
        didSet {
            users.sort { $0.score > $1.score }
        }
    }

    weak var delegate: LeaderboardViewModelDelegate?

    private var fetchLeaderboardState: State<[LeaderboardCollectionViewCellConfig]> = .unknown {
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
                self.users = users
                let cellConfigs: [LeaderboardCollectionViewCellConfig] = self.users.enumerated().map { LeaderboardCollectionViewCellConfig(name: $1.name, score: $1.score, number: $0 + 1) }
                self.fetchLeaderboardState = .loaded(cellConfigs)
            case .error(let error):
                self.fetchLeaderboardState = .error(error)
            }
        }
    }
}
