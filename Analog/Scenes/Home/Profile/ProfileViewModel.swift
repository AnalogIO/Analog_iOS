//
//  ProfileViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client

protocol ProfileViewModelDelegate: class {
    func didSetFetchUserState(state: State<User>)
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?
    let client = ClipCardAPI()
    var user: User?

    private var fetchUserState: State<User> = .unknown {
        didSet {
            delegate?.didSetFetchUserState(state: fetchUserState)
        }
    }

    let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    public func viewWillAppear() {
        fetchUser()
    }

    private func fetchUser() {
        fetchUserState = .loading
        User.get().response(using: provider.clipcard, method: .get, response: { response in
            switch response {
            case .error(let error):
                self.fetchUserState = .error(error)
            case .success(let user):
                self.user = user
                self.fetchUserState = .loaded(user)
            }
        })
    }
}
