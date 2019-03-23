//
//  TicketCollectionViewCell.swift
//  Analog
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

public class TicketCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier: String = "TicketCell"

    private let title = Views.title()
    private let stackView = Views.stackView()
    private let ticketsLeftView = Views.ticketsLeftView()
    private let ticketButtonView = Views.ticketButtonView()

    private let topMargin: CGFloat = 15
    private let stackViewMargin: CGFloat = 10

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        self.ticketButtonView.delegate = self
        self.layer.cornerRadius = 10
        self.addShadow()
        self.backgroundColor = .white
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

        stackView.addArrangedSubview(ticketsLeftView)
        stackView.addArrangedSubview(ticketButtonView)
    }
    
    public func configure(config: TicketCellConfig) {
        title.text = config.name
        ticketsLeftView.number.text = "2"
        ticketsLeftView.title.text = "Tickets left"
    }
}

extension TicketCollectionViewCell: TicketButtonViewDelegate {
    public func didPressBuyTickets() {
        ticketButtonView.type = .select
        print("buy")
    }

    public func didPressSelectTicket() {
        ticketButtonView.type = .buy
        print("select")
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
        stackView.clipsToBounds = true
        return stackView
    }

    static func ticketsLeftView() -> TitleSubtitleView {
        let view = TitleSubtitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func ticketButtonView() -> TicketButtonView {
        let view = TicketButtonView(type: .buy)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

public struct TicketCellConfig {
    let name: String

    public init(name: String) {
        self.name = name
    }
}
