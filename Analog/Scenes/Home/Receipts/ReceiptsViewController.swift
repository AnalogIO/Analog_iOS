//
//  ReceiptsViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import ShiftPlanningAPI
import Entities

class ReceiptsViewController: UIViewController {

    let segmentControl = Views.segmentedControl()
    let collectionView = Views.collectionView()

    let viewModel: ReceiptsViewModel
    var receiptConfigs: [ReceiptCellConfig] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var purchaseConfigs: [PurchaseCellConfig] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: ReceiptsViewModel) {
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
        title = "Receipts"
        view.backgroundColor = Color.grey

        defineLayout()
        setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    func defineLayout() {
        view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupTargets() {
        segmentControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    @objc func valueChanged(sender: UISegmentedControl) {
        viewModel.didSelectSegment(index: sender.selectedSegmentIndex)
    }
}

extension ReceiptsViewController: ReceiptsViewModelDelegate {

    func setSelectedSegment(index: Int) {
        segmentControl.selectedSegmentIndex = index
    }

    func showReceipt(receipt: Ticket) {
        present(receipt: receipt)
    }

    func didSetFetchPurchasesState(state: State<[PurchaseCellConfig]>) {
        switch state {
        case .loaded(let configs):
            indicator.stop()
            self.purchaseConfigs = configs
        case .loading:
            indicator.start()
        case .error(let error):
            indicator.stop()
            print(error.localizedDescription)
        default:
            break
        }
    }

    func didSetFetchReceiptsState(state: State<[ReceiptCellConfig]>) {
        switch state {
        case .loaded(let configs):
            indicator.stop()
            self.receiptConfigs = configs
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

extension ReceiptsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

extension ReceiptsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentControl.selectedSegmentIndex == 0 ? receiptConfigs.count : purchaseConfigs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentControl.selectedSegmentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReceiptCollectionViewCell.reuseIdentifier, for: indexPath) as! ReceiptCollectionViewCell
            let config = receiptConfigs[indexPath.row]
            cell.configure(config: config)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PurchaseCollectionViewCell.reuseIdentifier, for: indexPath) as! PurchaseCollectionViewCell
            let config = purchaseConfigs[indexPath.row]
            cell.configure(config: config)
            return cell
        }
    }
}

extension ReceiptsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width-16*2, height: 60)
    }
}

private enum Views {
    static func collectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(ReceiptCollectionViewCell.self, forCellWithReuseIdentifier: ReceiptCollectionViewCell.reuseIdentifier)
        collectionView.register(PurchaseCollectionViewCell.self, forCellWithReuseIdentifier: PurchaseCollectionViewCell.reuseIdentifier)
        return collectionView
    }

    static func segmentedControl() -> UISegmentedControl {
        let view = UISegmentedControl(items: ["Receipts", "Purchases"])
        view.tintColor = Color.espresso
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
