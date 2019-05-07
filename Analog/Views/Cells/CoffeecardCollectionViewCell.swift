//
//  CoffeecardCollectionViewCell.swift
//  Analog
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

public class CoffeecardCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier: String = "CoffeecardCell"

    private let title = Views.title()
    private let stackView = Views.stackView()
    private let coffeecardsLeftView = Views.coffeecardsLeftView()
    private let coffeecardButtonView = Views.coffeecardButtonView()

    private let topMargin: CGFloat = 15
    private let stackViewMargin: CGFloat = 15

    private var didPressShop: ((CoffeecardCollectionViewCell) -> Void)? = nil
    private var didPressSelect: ((CoffeecardCollectionViewCell) -> Void)? = nil

    public override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = Color.cortado
                title.textColor = Color.milk
                coffeecardsLeftView.title.textColor = Color.milk
                coffeecardsLeftView.number.textColor = Color.milk
                coffeecardButtonView.button.tintColor = Color.milk
                coffeecardButtonView.circleView.layer.borderColor = Color.milk.cgColor
            } else {
                backgroundColor = Color.milk
                title.textColor = Color.espresso
                coffeecardsLeftView.title.textColor = Color.espresso
                coffeecardsLeftView.number.textColor = Color.espresso
                coffeecardButtonView.button.tintColor = Color.cappuccino
                coffeecardButtonView.circleView.layer.borderColor = Color.cappuccino.cgColor
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        self.coffeecardButtonView.delegate = self
        self.layer.cornerRadius = 10
        self.addShadow()
        self.backgroundColor = Color.milk
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -topMargin),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: topMargin),
        ])

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: stackViewMargin),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -stackViewMargin),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -stackViewMargin),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackViewMargin),
        ])

        stackView.addArrangedSubview(coffeecardsLeftView)
        stackView.addArrangedSubview(coffeecardButtonView)
    }
    
    public func configure(config: CoffeecardCellConfig) {
        let type: ButtonType = config.ticketsLeft > 0 ? .select : .buy
        title.text = config.name
        coffeecardsLeftView.number.text = "\(config.ticketsLeft)"
        coffeecardsLeftView.title.text = "Tickets left"
        didPressSelect = config.didPressSelect
        didPressShop = config.didPressShop
        coffeecardButtonView.type = type
        coffeecardsLeftView.number.alpha = type == .buy ? 0.3 : 1
    }
}

extension CoffeecardCollectionViewCell: CoffeecardButtonViewDelegate {
    public func didPressBuyCoffeecards() {
        didPressShop?(self)
    }

    public func didPressSelectCoffeecard() {
        didPressSelect?(self)
    }
}

private enum Views {
    static func title() -> UILabel {
        let title = UILabel()
        title.textAlignment = .center
        title.font = Font.font(size: 28)
        title.textColor = Color.espresso
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }

    static func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }

    static func coffeecardsLeftView() -> TitleSubtitleView {
        let view = TitleSubtitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func coffeecardButtonView() -> CoffeecardButtonView {
        let view = CoffeecardButtonView(type: .select)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

public struct CoffeecardCellConfig {
    let name: String
    let ticketsLeft: Int
    let didPressShop: ((CoffeecardCollectionViewCell) -> Void)?
    let didPressSelect: ((CoffeecardCollectionViewCell) -> Void)?

    public init(name: String, ticketsLeft: Int, didPressShop: ((CoffeecardCollectionViewCell) -> Void)?, didPressSelect: ((CoffeecardCollectionViewCell) -> Void)?) {
        self.name = name
        self.ticketsLeft = ticketsLeft
        self.didPressShop = didPressShop
        self.didPressSelect = didPressSelect
    }
}
