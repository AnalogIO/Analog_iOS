//
//  ReceiptPopover.swift
//  Analog
//
//  Created by Frederik Christensen on 28/04/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import UIKit
import Entities

class ReceiptPopover: UIViewController {

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.milk
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.addShadow()
        return view
    }()

    let image: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "analog_logo_default"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 30)
        label.textColor = Color.espresso
        label.textAlignment = .center
        return label
    }()

    let ticketIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 12)
        label.textAlignment = .center
        label.textColor = Color.espresso
        return label
    }()

    let tapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 12)
        label.textAlignment = .center
        label.text = "Tap anywhere to dismiss"
        label.textColor = Color.espresso
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 18)
        label.textAlignment = .center
        label.textColor = Color.espresso
        return label
    }()

    let successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 24)
        label.textAlignment = .center
        label.textColor = Color.green
        label.text = "Success!"
        return label
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    var receipt: Ticket {
        didSet {
            updateView()
        }
    }

    let fadeTransition = FadeTransition()

    init(receipt: Ticket) {
        self.receipt = receipt
        super.init(nibName: nil, bundle: nil)
        defineLayout()
        setupTargets()

        transitioningDelegate = fadeTransition
        updateView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        view.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 400).isActive = true

        contentView.addSubview(stackView)
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        stackView.addArrangedSubview(successLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(tapLabel)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(ticketIdLabel)
    }

    private func setupTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        view.addGestureRecognizer(tap)
    }

    @objc private func didTapBackground(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    private func updateView() {
        titleLabel.text = receipt.productName
        ticketIdLabel.text = "Ticket ID: \(receipt.id)"
        dateLabel.text = DateFormat.format(receipt.dateUsed)
    }
}

