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

    let viewModel: TicketsViewModel

    init(viewModel: TicketsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tickets"
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()

        viewModel.viewDidLoad()
    }

    func defineLayout() {}

    func setupTargets() {}
}

extension TicketsViewController: TicketsViewModelDelegate {
    func didSetFetchTicketsState(state: State<[Ticket]>) {

    }
}

private enum Views {

}
