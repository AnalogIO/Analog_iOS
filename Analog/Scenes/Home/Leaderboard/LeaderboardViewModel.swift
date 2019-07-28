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
    func setSelectedSegment(index: Int)
}

class LeaderboardViewModel {

    var users: [LeaderboardUser] = [] {
        didSet {
            users.sort { $0.score > $1.score }
        }
    }

    private var selectedIndex: Int? = nil {
        didSet {
            guard let index = selectedIndex else { return }
            delegate?.setSelectedSegment(index: index)
            switch index {
            case 0:
                fetchLeaderboard(type: .semester)
            case 1:
                fetchLeaderboard(type: .month)
            default:
                fetchLeaderboard(type: .all)
            }
        }
    }

    weak var delegate: LeaderboardViewModelDelegate?

    private var fetchLeaderboardState: State<[LeaderboardCollectionViewCellConfig]> = .unknown {
        didSet {
            delegate?.didSetFetchLeaderboardState(state: fetchLeaderboardState)
        }
    }

    let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    public func viewWillAppear() {
        selectedIndex = 0
    }

    public func didSelectSegment(index: Int) {
        selectedIndex = index
    }

    private func fetchLeaderboard(type: LeaderboardType) {
        Leaderboard.get(type: type).response(using: provider.clipcard, method: .get) { response in
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
