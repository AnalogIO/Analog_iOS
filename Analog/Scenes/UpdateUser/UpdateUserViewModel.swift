//
//  UpdateUserViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 18/11/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client

protocol UpdateUserViewModelDelegate: class {
    func didUpdateUserState(state: State<User>)
}

class UpdateUserViewModel {
    public weak var delegate: UpdateUserViewModelDelegate?

    private var updateUserState: State<User> = .unknown {
        didSet {
            delegate?.didUpdateUserState(state: updateUserState)
        }
    }

    public func viewDidLoad() {}

    public func updateUser(type: UpdateType, value: String) {
        updateUserState = .loading
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        let parameters = [
            type.rawValue: value
        ]
        User.update().response(using: api, method: .put, parameters: parameters) { response in
            switch response {
            case .success(let user):
                self.persistUserData(user: user)
                self.updateUserState = .loaded(user)
            case .error(let error):
                self.updateUserState = .error(error)
            }
        }
    }

    private func persistUserData(user: User) {
        UserDefaults.standard.set(user.name, forKey: UpdateType.name.rawValue)
        UserDefaults.standard.set(user.email, forKey: UpdateType.email.rawValue)
    }
}
