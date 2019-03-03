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
    func didSetRegisterState(state: State<Message>)
}

class RegisterViewModel {

    public weak var delegate: RegisterViewModelDelegate?

    var registerState: State<Message> = .unknown {
        didSet {
            delegate?.didSetRegisterState(state: registerState)
        }
    }

    func viewDidLoad() {}

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
                self.registerState = .loaded(value)
            case .error(let error):
                self.registerState = .error(error)
            }
        }
    }
}
