//
//  OnboardingViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Entities
import ClipCardAPI

protocol OnboardingViewModelDelegate: class {
    func didSetFetchProgrammesState(state: State<[Programme]>)
}

class OnboardingViewModel {

    public weak var delegate: OnboardingViewModelDelegate?

    var fetchProgrammesState: State<[Programme]> = .unknown {
        didSet {
            delegate?.didSetFetchProgrammesState(state: fetchProgrammesState)
        }
    }

    func viewDidLoad() {
        fetchProgrammes()
    }

    func fetchProgrammes() {
        fetchProgrammesState = .loading
        let api = ClipCardAPI()
        Programme.getAll().response(using: api, method: .get) { response in
            switch response {
            case .success(let value):
                self.fetchProgrammesState = .loaded(value)
            case .error(let error):
                self.fetchProgrammesState = .error(error)
            }
        }
    }

    func register(name: String, email: String, password: String, programme: Programme) {
        print("Registering...")
    }
}
