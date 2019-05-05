//
//  LeaderboardViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

class LeaderboardViewController: UIViewController {

    let collectionView = Views.collectionView()
    let nameLabel = Views.nameLabel()
    let scoreLabel = Views.scoreLabel()

    var cellConfigs: [LeaderboardCollectionViewCellConfig] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var indicator = ActivityIndication(container: view)

    let viewModel: LeaderboardViewModel

    init(viewModel: LeaderboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leaderboard"
        view.backgroundColor = Color.grey

        defineLayout()
        setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    private func defineLayout() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])

        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTargets() {}
}

extension LeaderboardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellConfigs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeaderboardCollectionViewCell.reuseIdentifier, for: indexPath) as! LeaderboardCollectionViewCell
        let config = cellConfigs[indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

extension LeaderboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width-16*2, height: 60)
    }
}

extension LeaderboardViewController: LeaderboardViewModelDelegate {
    func didSetFetchLeaderboardState(state: State<[LeaderboardCollectionViewCellConfig]>) {
        switch state {
        case .loaded(let configs):
            indicator.stop()
            self.cellConfigs = configs
        case .loading:
            indicator.start()
        case .error(let error):
            indicator.stop()
            print(error.localizedDescription)
        default:
            break
        }
    }
}

private enum Views {
    static func collectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(LeaderboardCollectionViewCell.self, forCellWithReuseIdentifier: LeaderboardCollectionViewCell.reuseIdentifier)
        return collectionView
    }

    static func nameLabel() -> UILabel {
        let label = UILabel()
        label.text = "NAME"
        label.textAlignment = .left
        label.textColor = Color.espresso
        label.font = Font.font(size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func scoreLabel() -> UILabel {
        let label = UILabel()
        label.text = "SCORE"
        label.textAlignment = .right
        label.textColor = Color.espresso
        label.font = Font.font(size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
