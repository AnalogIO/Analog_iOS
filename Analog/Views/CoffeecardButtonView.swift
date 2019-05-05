//
//  CoffeecardButtonView.swift
//  Analog
//
//  Created by Frederik Christensen on 23/03/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation

public protocol CoffeecardButtonViewDelegate: class {
    func didPressBuyCoffeecards()
    func didPressSelectCoffeecard()
}

public enum ButtonType {
    case buy
    case select
}

public class CoffeecardButtonView: UIView {

    weak var delegate: CoffeecardButtonViewDelegate?

    let circleMargin: CGFloat = 10

    let button = Views.button()
    let circleView = Views.circleView()

    var type: ButtonType {
        didSet {
            updateView()
        }
    }

    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)

        defineLayout()
        setupTargets()

        updateView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.heightAnchor.constraint(equalTo: heightAnchor, constant: -circleMargin),
            circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor),
        ])

        circleView.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            button.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.55),
            button.widthAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.55),
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = circleView.bounds.width / 2
    }

    private func setupTargets() {
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
    }

    private func updateView() {
        switch type {
        case .buy:
            button.setImage(#imageLiteral(resourceName: "ticket_shop").withRenderingMode(.alwaysTemplate), for: .normal)
        case .select:
            button.setImage(#imageLiteral(resourceName: "ticket_coffee").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

    @objc private func didPressButton(sender: UIButton) {
        switch type {
        case .buy:
            delegate?.didPressBuyCoffeecards()
        case .select:
            delegate?.didPressSelectCoffeecard()
        }
    }
}

private enum Views {
    static func button() -> UIButton {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Color.cappuccino
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }

    static func circleView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = Color.cappuccino.cgColor
        view.layer.borderWidth = 3
        view.backgroundColor = .clear
        return view
    }
}
