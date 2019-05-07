//
//  RegisterViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Entities
import ClipCardAPI

protocol RegisterViewModelDelegate: class {
    func didSetRegisterState(state: State<ValueMessage>)
}

class RegisterViewModel {

    public weak var delegate: RegisterViewModelDelegate?

    var registerState: State<ValueMessage> = .unknown {
        didSet {
            delegate?.didSetRegisterState(state: registerState)
        }
    }

    func register(name: String, email: String, password: String) {
        registerState = .loading
        let api = ClipCardAPI()
        let parameters = [
            "name": name,
            "email": email,
            "password": password.sha256(),
            "programmeId": "1",
        ]
        User.register().response(using: api, method: .post, parameters: parameters, headers: [:]) { response in
            switch response {
            case .success(let value):
                KeyChainService.shared.store(key: .email, value: email)
                UserDefaults.standard.set(false, forKey: UserDefaultKey.isFaceTouchEnabled.rawValue)
                self.registerState = .loaded(value)
            case .error(let error):
                self.registerState = .error(error)
            }
        }
    }
}
