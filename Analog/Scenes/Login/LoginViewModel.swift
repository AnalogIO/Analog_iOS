//
//  LoginViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Entities
import ShiftPlanningAPI
import ClipCardAPI

protocol LoginViewModelDelegate: class {
    func didSetFetchCafeState(state: State<Cafe>)
    func didSetFetchTokenState(state: State<Token>)
}

class LoginViewModel {

    weak var delegate: LoginViewModelDelegate?

    let email: String
    let version: String

    var fetchCafeState: State<Cafe> = .unknown {
        didSet {
            delegate?.didSetFetchCafeState(state: fetchCafeState)
        }
    }

    var fetchTokenState: State<Token> = .unknown {
        didSet {
            delegate?.didSetFetchTokenState(state: fetchTokenState)
        }
    }

    init(email: String) {
        self.email = email
        self.version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    public func viewDidLoad() {
        fetchCafeStatus()
    }

    private func fetchCafeStatus() {
        fetchCafeState = .loading
        let api = ShiftPlanningAPI()
        Cafe.isOpen().response(using: api, method: .get) { response in
            switch response {
            case .success(let value):
                self.fetchCafeState = .loaded(value)
            case .error(let error):
                self.fetchCafeState = .error(error)
            }
        }
    }

    public func login(password: String) {
        fetchTokenState = .loading
        let api = ClipCardAPI()
        let parameters = [
            "email": email,
            "password": password.sha256(),
            "version": version,
        ]
        User.login().response(using: api, method: .post, parameters: parameters) { response in
            switch response {
            case .success(let value):
                KeyChainService.shared.store(key: .token, value: value.token)
                self.fetchTokenState = .loaded(value)
            case .error(let error):
                self.fetchTokenState = .error(error)
            }
        }
    }
}
