//
//  MoreTableViewCell.swift
//  Views
//
//  Created by Frederik Christensen on 24/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

public class MoreTableViewCell: UITableViewCell {
    public static let reuseIdentifier: String = "MoreCell"

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(config: MoreTableViewCellConfig) {
        imageView?.image = config.icon
        textLabel?.text = config.title

        switch config.type {
        case .normal:
            accessoryType = .disclosureIndicator
            textLabel?.textColor = .black
            textLabel?.textAlignment = .natural
        case .escape:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }
}

public struct MoreTableViewCellConfig {
    let icon: UIImage?
    let title: String
    let type: MoreTableViewCellType

    public init(icon: UIImage? = nil, title: String, type: MoreTableViewCellType = .normal) {
        self.icon = icon
        self.title = title
        self.type = type
    }
}

public enum MoreTableViewCellType {
    case normal
    case escape
}
