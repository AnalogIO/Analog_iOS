//
//  TicketsViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import ShiftPlanningAPI
import Entities

class TicketsViewController: UIViewController {

    let collectionViewSideMargin: CGFloat = 50

    let collectionView = Views.collectionView()
    let viewModel: TicketsViewModel
    var ticketConfigs: [TicketCellConfig] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: TicketsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbarLogo()
        view.backgroundColor = Color.grey

        defineLayout()
        setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    func defineLayout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupTargets() {}
}

extension TicketsViewController: TicketsViewModelDelegate {
    func didSetFetchOrderIdState(state: State<MPOrder>) {
        switch state {
        case .loaded(let order):
            indicator.stop()
            print(order.orderId)
        case .loading:
            indicator.start()
        case .error(let error):
            indicator.stop()
            displayMessage(title: "Missing application", message: error.localizedDescription, actions: [.Ok])
        default:
            break
        }
    }
    
    func didSetFetchTicketsState(state: State<[TicketCellConfig]>) {
        switch state {
        case .loaded(let configs):
            indicator.stop()
            self.ticketConfigs = configs
        case .loading:
            indicator.start()
        case .error(let error):
            indicator.stop()
            displayMessage(title: "Error", message: error.localizedDescription, actions: [.Ok])
        default:
            break
        }
    }
}

extension TicketsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

extension TicketsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ticketConfigs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketCollectionViewCell.reuseIdentifier, for: indexPath) as! TicketCollectionViewCell
        let config = ticketConfigs[indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

extension TicketsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: collectionViewSideMargin, bottom: 20, right: collectionViewSideMargin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width-(collectionViewSideMargin*2)
        return CGSize(width: width, height: width*0.52)
    }
}

private enum Views {
    static func collectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 30
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(TicketCollectionViewCell.self, forCellWithReuseIdentifier: TicketCollectionViewCell.reuseIdentifier)
        return collectionView
    }
}
