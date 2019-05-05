//
//  UIView.swift
//  Analog
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static func spacing(_ height: CGFloat, required: Bool = true, priority: UILayoutPriority = .required) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if required {
            let constraint = view.heightAnchor.constraint(equalToConstant: height)
            constraint.priority = priority
            constraint.isActive = true
        } else {
            let constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            constraint.priority = priority
            view.setContentHuggingPriority(.defaultLow, for: .vertical)
            constraint.isActive = true
        }
        return view
    }

    public func addShadow(opacity: Float = 0.4, offset: CGSize = CGSize(width: 3, height: 3)) {
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
    }

    static func emptySpace() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        return view
    }
}
