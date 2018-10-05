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

    public func login(email: String, password: String) {
        fetchTokenState = .loading
        let api = ClipCardAPI()
        let parameters = [
            "email": email,
            "password": password.sha256(),
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
        ]
        User.login().response(using: api, method: .post, parameters: parameters) { response in
            switch response {
            case .success(let token):
                KeyChainService.shared.store(key: .token, value: token.token)
                self.fetchTokenState = .loaded(token)
                self.fetchUser()
            case .error(let error):
                self.fetchTokenState = .error(error)
            }
        }
    }

    private func fetchUser() {
        let api = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
        User.get().response(using: api, method: .get, response: { response in
            switch response {
            case .success(let user):
                self.persistUserData(user: user)
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }

    private func persistUserData(user: User) {
        UserDefaults.standard.set(user.name, forKey: "name")
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.programme, forKey: "programme")
    }
}
