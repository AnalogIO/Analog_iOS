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
    let swipeButton = Views.swipeButton()
    
    let viewModel: TicketsViewModel
    var coffeecardConfigs: [CoffeecardCellConfig] = [] {
        didSet {
            coffeecardConfigs.sort { $0.ticketsLeft > $1.ticketsLeft }
            self.collectionView.reloadData()
        }
    }

    lazy var swipeButtonHiddenConstraints: [NSLayoutConstraint] = [
        swipeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        swipeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        swipeButton.heightAnchor.constraint(equalToConstant: 70),
        swipeButton.topAnchor.constraint(equalTo: view.bottomAnchor),
    ]

    lazy var swipeButtonVisibleConstraints: [NSLayoutConstraint] = [
        swipeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        swipeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        swipeButton.heightAnchor.constraint(equalToConstant: 70),
        swipeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
    ]

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
        view.backgroundColor = Color.grey
        title = "Tickets"

        defineLayout()
        setupTargets()

        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "VoucherShop").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(didPressVoucher))
        barButton.tintColor = Color.milk
        navigationItem.rightBarButtonItem = barButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }

    func defineLayout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        view.addSubview(swipeButton)
        NSLayoutConstraint.activate(swipeButtonHiddenConstraints)
    }

    func setupTargets() {
        swipeButton.addTarget(self, action: #selector(swipeButtonDidChange), for: .valueChanged)
        NotificationCenter.default.addObserver(self,selector: #selector(mobilepayDidFinishWithSuccess), name: NSNotification.Name(rawValue: "mobilepay_transaction_success"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(mobilepayDidFinishWithError), name: NSNotification.Name(rawValue: "mobilepay_transaction_error"), object: nil)
    }

    @objc func mobilepayDidFinishWithSuccess(notification: NSNotification) {
        viewModel.fetchTickets()
    }

    @objc func mobilepayDidFinishWithError(notification: NSNotification) {
        guard let error = notification.object as? Error else { return }
        displayMessage(title: "Error", message: error.localizedDescription, actions: [.Ok])
    }

    @objc private func swipeButtonDidChange(sender: SwipeButton) {
        switch sender.swipeState {
        case .off:
            print("off")
        case .hidden:
            print("hidden")
        case .spinning:
            viewModel.didSwipe()
        }
    }

    @objc private func didPressVoucher(sender: UIBarButtonItem) {
        let vc = VoucherViewController(viewModel: VoucherViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TicketsViewController: TicketsViewModelDelegate {
    func showReceipt(receipt: Ticket) {
        present(receipt: receipt)
    }
    
    func resetSwipeButton() {
        swipeButton.reset()
    }

    func hideSwipeButton(animated: Bool) {
        NSLayoutConstraint.deactivate(swipeButtonVisibleConstraints)
        NSLayoutConstraint.activate(swipeButtonHiddenConstraints)
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.view.layoutIfNeeded()
        }
    }

    func showSwipeButton(animated: Bool) {
        NSLayoutConstraint.deactivate(swipeButtonHiddenConstraints)
        NSLayoutConstraint.activate(swipeButtonVisibleConstraints)
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.view.layoutIfNeeded()
        }
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func index(for cell: CoffeecardCollectionViewCell) -> Int? {
        return collectionView.indexPath(for: cell)?.row
    }

    func didSetUseTicketState(state: State<Ticket>) {
        switch state {
        case .loaded(let ticket):
            indicator.stop()
            showReceipt(receipt: ticket)
        case .loading:
            indicator.start()
        case .error(let error):
            indicator.stop()
            print(error.localizedDescription)
        default:
            break
        }
    }

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
    
    func didSetFetchCoffeecardsState(state: State<[CoffeecardCellConfig]>) {
        switch state {
        case .loaded(let configs):
            indicator.stop()
            self.coffeecardConfigs = configs
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

extension TicketsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coffeecardConfigs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoffeecardCollectionViewCell.reuseIdentifier, for: indexPath) as! CoffeecardCollectionViewCell
        let config = coffeecardConfigs[indexPath.row]
        cell.configure(config: config)
        cell.isSelected = viewModel.isCellSelected(index: indexPath.row)
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
        collectionView.register(CoffeecardCollectionViewCell.self, forCellWithReuseIdentifier: CoffeecardCollectionViewCell.reuseIdentifier)
        collectionView.allowsSelection = false
        return collectionView
    }

    static func swipeButton() -> SwipeButton {
        let button = SwipeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
