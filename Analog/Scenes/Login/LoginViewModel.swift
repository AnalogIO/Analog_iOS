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
    func didSetFetchUserState(state: State<User>)
}

class LoginViewModel {

    weak var delegate: LoginViewModelDelegate?

    var fetchCafeState: State<Cafe> = .unknown {
        didSet {
            delegate?.didSetFetchCafeState(state: fetchCafeState)
        }
    }

    var fetchUserState: State<User> = .unknown {
        didSet {
            delegate?.didSetFetchUserState(state: fetchUserState)
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
        fetchUserState = .loading
        let api = ClipCardAPI()
        let parameters = [
            "email": email,
            "password": password.sha256(),
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
        ]
        User.login().response(using: api, method: .post, parameters: parameters) { response in
            switch response {
            case .success(let user):
                self.persistUserData(user: user)
                self.fetchUserState = .loaded(user)
            case .error(let error):
                self.fetchUserState = .error(error)
            }
        }
    }

    private func persistUserData(user: User) {
        UserDefaults.standard.set(user.name, forKey: "name")
        UserDefaults.standard.set(user.email, forKey: "email")
        //UserDefaults.standard.set(user.programme, forKey: "programme")
        KeyChainService.shared.store(key: .token, value: user.token)
    }
}
