//
//  MoreViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

protocol MoreViewModelDelegate: class {}

class MoreViewModel {
    weak var delegate: MoreViewModelDelegate?

    func viewWillAppear() {}
}
