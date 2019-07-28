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
    func didSetFetchForgotPasswordState(state: State<Message>)
    func startFaceTouchAuthentication()
    func showMessage(text: String)
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

    var fetchForgotPasswordState: State<Message> = .unknown {
        didSet {
            delegate?.didSetFetchForgotPasswordState(state: fetchForgotPasswordState)
        }
    }

    public func viewDidLoad() {
        fetchCafeStatus()
    }

    public func viewWillAppear() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey.isFaceTouchEnabled.rawValue) {
            delegate?.startFaceTouchAuthentication()
        }
    }

    public func loginWithStoredCredentials() {
        if let email = KeyChainService.shared.get(key: .email), let pin = KeyChainService.shared.get(key: .pin) {
            login(email: email, password: pin)
        } else {
            delegate?.showMessage(text: "Credentials are not stored on device, please login manually and re-activate Face/Touch ID")
        }
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

    public func forgotPassword(email: String) {
        fetchForgotPasswordState = .loading
        let api = ClipCardAPI()
        let parameters = [
            "email": email
        ]
        User.forgotPassword().response(using: api, method: .post, parameters: parameters) { response in
            switch response {
            case .success(let message):
                self.fetchForgotPasswordState = .loaded(message)
            case .error(let error):
                self.fetchForgotPasswordState = .error(error)
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
                KeyChainService.shared.store(key: .email, value: email)
                KeyChainService.shared.store(key: .pin, value: password)
                self.fetchTokenState = .loaded(token)
            case .error(let error):
                self.fetchTokenState = .error(error)
            }
        }
    }
}
