//
//  FDCActivityIndicator.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 22/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import UIKit

public class ActivityIndication {
    let container: UIView
    let blurEffectView = Views.blurEffectView()
    let activityIndicator = Views.activityIndicator()

    public init(container: UIView) {
        self.container = container
        defineLayout()
    }

    func defineLayout() {
        container.addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.widthAnchor.constraint(equalToConstant: 100),
            blurEffectView.heightAnchor.constraint(equalToConstant: 100),
            blurEffectView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            blurEffectView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        blurEffectView.contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
        ])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        blurEffectView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    public func stop() {
        blurEffectView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}

private enum Views {
    static func activityIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        view.color = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        view.contentMode = .scaleToFill
        return view
    }

    static func blurEffectView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 24
        blurEffectView.clipsToBounds = true
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }
}
