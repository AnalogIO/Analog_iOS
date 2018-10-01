//
//  UIView.swift
//  Views
//
//  Created by Frederik Christensen on 30/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

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
            constraint.isActive = true
        }
        return view
    }
}
