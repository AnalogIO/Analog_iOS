//
//  MoreTableViewCell.swift
//  Views
//
//  Created by Frederik Christensen on 24/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

public class StaticTableViewCell: UITableViewCell {
    public static let reuseIdentifier: String = "StaticCell"

    private let switchButton = Views.switchButton()
    private let centerLabel = Views.centerLabel()

    private var switchAction: ((UISwitch) -> Void)?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white

        defineLayout()
        setupTargets()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(switchButton)
        NSLayoutConstraint.activate([
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])

        addSubview(centerLabel)
        NSLayoutConstraint.activate([
            centerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func setupTargets() {
        switchButton.addTarget(self, action: #selector(didTapSwitch), for: .valueChanged)
    }

    public func configure(config: StaticTableViewCellConfig) {
        imageView?.image = config.icon
        textLabel?.text = config.title
        detailTextLabel?.text = config.detail
        switchAction = config.switchAction

        switch config.type {
        case .normal:
            accessoryType = .disclosureIndicator
        case .switch:
            switchButton.alpha = 1
        case .escape:
            centerLabel.textColor = .red
            centerLabel.text = textLabel?.text
            centerLabel.alpha = 1
            textLabel?.alpha = 0
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        centerLabel.alpha = 0
        textLabel?.alpha = 1
        switchButton.alpha = 0
        accessoryType = .none
    }

    @objc private func didTapSwitch(sender: UISwitch) {
        switchAction?(sender)
    }
}

public struct StaticTableViewCellConfig {
    public let icon: UIImage?
    public let title: String
    public let detail: String?
    public let type: StaticTableViewCellType
    public let click: (() -> Void)?
    public let switchAction: ((UISwitch) -> Void)?

    public init(icon: UIImage? = nil, title: String, detail: String? = "", type: StaticTableViewCellType = .normal, click: (() -> Void)? = nil, switchAction: ((UISwitch) -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.detail = detail
        self.type = type
        self.click = click
        self.switchAction = switchAction
    }
}

public enum StaticTableViewCellType {
    case normal
    case `switch`
    case escape
}

private enum Views {
    static func switchButton() -> UISwitch {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isOn = false
        view.alpha = 0
        return view
    }

    static func centerLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        label.textAlignment = .center
        return label
    }
}

public struct StaticSection {
    public let cellConfigs: [StaticTableViewCellConfig]

    public init(cellConfigs: [StaticTableViewCellConfig]) {
        self.cellConfigs = cellConfigs
    }
}
