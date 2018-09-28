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

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(config: StaticTableViewCellConfig) {
        imageView?.image = config.icon
        textLabel?.text = config.title

        switch config.type {
        case .normal:
            accessoryType = .disclosureIndicator
            textLabel?.textColor = .black
            textLabel?.textAlignment = .natural
        case .escape:
            accessoryType = .none
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }
}

public struct StaticTableViewCellConfig {
    public let icon: UIImage?
    public let title: String
    public let type: StaticTableViewCellType
    public let action: (() -> Void)?

    public init(icon: UIImage? = nil, title: String, type: StaticTableViewCellType = .normal, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.type = type
        self.action = action
    }
}

public enum StaticTableViewCellType {
    case normal
    case escape
}
