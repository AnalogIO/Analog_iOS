//
//  ShopViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client
import Views

protocol ShopViewModelDelegate: class {}

class ShopViewModel {
    public weak var delegate: ShopViewModelDelegate?

    public func viewDidLoad() {}
}
