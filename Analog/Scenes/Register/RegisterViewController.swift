//
//  RegisterViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

class RegisterViewController: UIPageViewController {

    let viewModel: RegisterViewModel

    var email: String?
    var name: String?
    var password: String?

    var currentIndex: Int? {
        didSet {
            guard let index = currentIndex else { return }
            setViewControllers([vcs[index]], direction: .forward, animated: true, completion: nil)
        }
    }

    let vcs: [InputViewController] = [
        InputViewController(type: .name),
        InputViewController(type: .email),
        InputViewController(type: .password),
    ]

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        viewModel.delegate = self
        vcs.forEach { $0.delegate = self }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        currentIndex = 0
    }

    private func register() {
        guard let name = name, let email = email, let password = password else {
            displayMessage(title: "Something went wrong...", message: "Please try to register again", actions: [.Ok], completion: {
                self.reset()
            })
            return
        }
        viewModel.register(name: name, email: email, password: password)
    }

    private func reset() {
        vcs.forEach { $0.reset() }
        currentIndex = 0
    }

    private func navigateToLogin() {
        let loginVC = LoginViewController(viewModel: LoginViewModel())
        present(loginVC, animated: true, completion: nil)
    }
}

extension RegisterViewController: InputViewControllerDelegate {
    func didPressLoginButton() {
        navigateToLogin()
    }

    func didReceiveInput(type: InputType, input: String) {
        switch type {
        case .email:
            email = input
            currentIndex? += 1
        case .name:
            name = input
            currentIndex? += 1
        case .password:
            password = input
            register()
        }
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func didSetRegisterState(state: State<Message>) {
        switch state {
        case .loading:
            print("Loading...")
        case .loaded(_):
            let vc = LoginViewController(viewModel: LoginViewModel())
            present(vc, animated: true, completion: nil)
        case .error(let error):
            print(error)
        default:
            break
        }
    }
}

private enum Views {}
