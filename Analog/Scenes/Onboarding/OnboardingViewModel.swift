//
//  OnboardingViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

protocol OnboardingViewModelDelegate: class {}

class OnboardingViewModel {

    weak var delegate: OnboardingViewModelDelegate?

    func viewDidLoad() {}
}
