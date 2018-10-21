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
import Views

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
        Leaderboard.get().response(using: api, method: .get) { response in
            switch response {
            case .success(let leaderboard):
                //TODO: map leaderboard to configs
                let cellConfigs: [LeaderboardTableViewCellConfig] = []
                self.fetchLeaderboardState = .loaded(cellConfigs)
            case .error(let error):
                self.fetchLeaderboardState = .error(error)
            }
        }
    }
}
