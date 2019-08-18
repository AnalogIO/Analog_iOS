//
//  VoucherViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Client
import Entities

class VoucherViewController: UIViewController {

    lazy var indicator = ActivityIndication(container: view)

    private let scrollView = Views.scrollView()
    private let stackView = Views.stackView()
    private let titleLabel = Views.titleLabel()
    private let sendButton = Views.sendButton()
    private let inputField = Views.inputField()

    private let topMargin: CGFloat = 30
    private let sideMargin: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.25 : 25
    private let sendButtonMargin: CGFloat = 30
    private let inputFieldHeight: CGFloat = 50
    private let sendButtonHeight: CGFloat = 40
    private let imageViewHeight: CGFloat = 60

    private let viewModel: VoucherViewModel

    init(viewModel: VoucherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Redeem Voucher"
        view.backgroundColor = Color.grey

        defineLayout()
        setupTargets()

        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputField.becomeFirstResponder()
    }

    private func defineLayout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideMargin),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideMargin),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin),
        ])

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(.spacing(25))
        stackView.addArrangedSubview(inputField)
        stackView.addArrangedSubview(.spacing(25))
        stackView.addArrangedSubview(sendButton)

        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalToConstant: sendButtonHeight),
            sendButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: sendButtonMargin),
            sendButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -sendButtonMargin),
            inputField.heightAnchor.constraint(equalToConstant: inputFieldHeight),
            inputField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            inputField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }

    private func setupTargets() {
        sendButton.addTarget(self, action: #selector(didPressSendButton), for: .touchUpInside)
    }

    @objc func didPressSendButton(sender: UIButton) {
        guard let input = inputField.text else { return }
        viewModel.didPressSendButton(code: input)
    }

    private func updateView() {
        titleLabel.text = "Enter code"
    }

    public func reset() {
        inputField.text = nil
    }
}

private enum Views {
    static func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func scrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = false
        scrollView.layer.masksToBounds = false
        return scrollView
    }

    static func sendButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.yellow
        button.setTitle("Send", for: .normal)
        button.setTitleColor(Color.milk, for: .normal)
        button.titleLabel?.font = Font.boldFont(size: 18)
        button.addShadow()
        return button
    }

    static func inputField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Color.milk
        textField.addShadow()
        textField.layer.cornerRadius = 4
        textField.textAlignment = .center
        textField.tintColor = Color.espresso
        textField.borderStyle = .none
        return textField
    }

    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldFont(size: 28)
        label.textAlignment = .center
        label.textColor = Color.espresso
        return label
    }
}

extension VoucherViewController: VoucherViewModelDelegate {
    func didRedeemVoucherState(state: State<Purchase>) {
        switch state {
        case .loaded(_):
            indicator.stop()
            navigationController?.popViewController(animated: true)
        case .error(let error):
            indicator.stop()
            displayMessage(title: "Message", message: error.localizedDescription, actions: [.Ok])
        case .loading:
            indicator.start()
        default:
            break
        }
    }
}
