//
//  UINavigationItem.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/20/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

extension UINavigationItem {

    func set(icon: IonIconType, forButton button: UIBarButtonItem) {
        button.title = icon.rawValue
        button.setTitleTextAttributes([
            NSFontAttributeName: UIFont.ionIconFont(ofSize: FontManager.currentFont.titleSize)
            ], for: .normal)
    }

    func set(leftButtonIcon icon: IonIconType, target: Any?, action: Selector?) {
        let button = UIBarButtonItem(title: nil, style: .plain, target: target, action: action)
        self.set(icon: icon, forButton: button)
        self.leftBarButtonItem = button
    }

    func set(rightButtonIcon icon: IonIconType, target: Any?, action: Selector?) {
        let button = UIBarButtonItem(title: nil, style: .plain, target: target, action: action)
        self.set(icon: icon, forButton: button)
        self.rightBarButtonItem = button
    }

}
