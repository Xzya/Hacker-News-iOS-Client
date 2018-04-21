//
//  AlertBuilder.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

class AlertBuilder {

    // MARK: - Properties

    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

    // MARK: - Helpers

    func set(title: String?) -> Self {
        self.alertController.title = title
        return self
    }

    func set(message: String?) -> Self {
        self.alertController.message = message
        return self
    }

    func add(actionWithTitle title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        self.alertController.addAction(
            UIAlertAction(
                title: title,
                style: style,
                handler: handler)
        )
        return self
    }

    func present(sender: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        sender.present(self.alertController, animated: animated, completion: completion)
    }

}
