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

    let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    public func viewDidLoad() {}

    public func updateUser(type: UpdateType, value: String) {
        updateUserState = .loading
        let parameters = [
            type.rawValue: type == .password ? value.sha256() : value
        ]
        User.update().response(using: provider.clipcard, method: .put, parameters: parameters) { response in
            switch response {
            case .success(let user):
                KeyChainService.shared.store(key: .email, value: user.email)
                if type == .password { KeyChainService.shared.store(key: .pin, value: value) }
                self.updateUserState = .loaded(user)
            case .error(let error):
                self.updateUserState = .error(error)
            }
        }
    }
}
