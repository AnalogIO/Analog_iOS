//
//  RankView.swift
//  Analog
//
//  Created by Frederik Christensen on 28/04/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import UIKit
import Entities

public class RankView: UIView {
    private let monthView: RankInfoView = {
        let view = RankInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = "MONTH"
        view.subtitle.text = "-"
        return view
    }()

    private let semesterView: RankInfoView = {
        let view = RankInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = "SEMESTER"
        view.subtitle.text = "-"
        return view
    }()

    private let alltimeView: RankInfoView = {
        let view = RankInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.text = "ALL-TIME"
        view.subtitle.text = "-"
        return view
    }()

    let rankLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Color.milk
        label.font = Font.font(size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rank"
        return label
    }()

    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.backgroundColor = .clear
        view.distribution = .fillEqually
        return view
    }()

    var user: User? {
        didSet {
            updateView()
        }
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = Color.cortado
        layer.cornerRadius = 10
        addShadow()
        defineLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(rankLabel)
        rankLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        rankLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        addSubview(stackView)
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: rankLabel.bottomAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

        stackView.addArrangedSubview(monthView)
        stackView.addArrangedSubview(semesterView)
        stackView.addArrangedSubview(alltimeView)
    }

    private func updateView() {
        guard let user = user else { return }
        monthView.subtitle.text = "\(user.rankMonth)"
        alltimeView.subtitle.text = "\(user.rankAllTime)"
        semesterView.subtitle.text = "\(user.rankSemester)"
    }
}

private class RankInfoView: UIView {
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Color.grey
        label.font = Font.font(size: 10)
        return label
    }()

    let subtitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Color.milk
        label.font = Font.font(size: 27)
        return label
    }()

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)
        defineLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        addSubview(stackView)
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)
    }
}
