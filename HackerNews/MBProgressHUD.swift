//
//  MBProgressHUD.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {

    static func showLoader(view: UIView, animated: Bool = true, interactionDisabled: Bool = true) {
        if interactionDisabled {
            view.isUserInteractionEnabled = false
        }
        MBProgressHUD.showAdded(to: view, animated: animated)
    }

    static func hideLoader(view: UIView, animated: Bool = true, interactionEnabled: Bool = true) {
        if interactionEnabled {
            view.isUserInteractionEnabled = true
        }
        MBProgressHUD.hide(for: view, animated: animated)
    }

}
