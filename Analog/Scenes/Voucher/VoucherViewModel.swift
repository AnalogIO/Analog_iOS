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

protocol VoucherViewModelDelegate: class {
    func didRedeemVoucherState(state: State<Purchase>)
}

class VoucherViewModel {

    private var redeemVoucherState: State<Purchase> = .unknown {
        didSet {
            delegate?.didRedeemVoucherState(state: redeemVoucherState)
        }
    }

    public weak var delegate: VoucherViewModelDelegate?

    let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    public func didPressSendButton(code: String) {
        redeemVoucherState = .loading
        let parameters = [
            "voucherCode": code
        ]
        Purchase.redeemVoucher().response(using: provider.clipcard, method: .post, parameters: parameters) { response in
            switch response {
            case .success(let purchase):
                self.redeemVoucherState = .loaded(purchase)
            case .error(let error):
                self.redeemVoucherState = .error(error)
            }
        }
    }
}
