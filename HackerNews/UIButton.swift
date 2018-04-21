//
//  UIButton.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/20/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

extension UIButton {

    func setTitleWithoutAnimation(_ title: String?, for state: UIControlState) {
        UIView.setAnimationsEnabled(false)
        self.setTitle(title, for: state)
        self.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }

    func setAttributedTitleWithoutAnimation(_ title: NSAttributedString?, for state: UIControlState) {
        UIView.setAnimationsEnabled(false)
        self.setAttributedTitle(title, for: state)
        self.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }

}
