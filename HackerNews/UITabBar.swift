//
//  UITabBar.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/26/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

extension UITabBar {

    func set(topBorderColor color: UIColor, height: CGFloat) {
        let borderView = UIView(frame: CGRect(x: 0, y: -0.5, width: frame.width, height: height))
        borderView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        borderView.backgroundColor = color

        self.addSubview(borderView)
    }

}
