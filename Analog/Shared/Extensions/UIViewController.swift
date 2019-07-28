//
//  UIViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 17/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

extension UIViewController {

    enum ActionType {
        case Ok
        case Cancel
        case Retry((UIAlertAction) -> Void)
    }

    func displayMessage(title: String, message: String, actions: [ActionType], completion: (() -> Void)? = nil, okHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.enumerated().forEach { index, type in
            let action: UIAlertAction
            switch type {
            case .Ok:
                action = UIAlertAction(title: "Ok", style: .default, handler: okHandler)
            case .Cancel:
                action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            case .Retry(let handler):
                action = UIAlertAction(title: "Retry", style: .default, handler: handler)
            }
            alert.addAction(action)
        }
        present(alert, animated: true, completion: completion)
    }

    func requestInput(title: String, message: String, completion: ((String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { controller -> Void in
            guard let textFields = alert.textFields, textFields.count > 0 else { return }
            completion?(textFields[0].text)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email"
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    func present(receipt: Ticket) {
        let popover = ReceiptPopover(receipt: receipt)
        popover.modalPresentationStyle = .custom
        present(popover, animated: true, completion: nil)
    }
}
