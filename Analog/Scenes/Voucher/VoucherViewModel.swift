//
//  VoucherViewModel.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import ClipCardAPI
import Entities
import Client

protocol VoucherViewModelDelegate: class {}

class VoucherViewModel {
    public weak var delegate: VoucherViewModelDelegate?

    public func didPressSendButton(code: String) {
        print("Using voucher: \(code)")
    }
}
