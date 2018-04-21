//
//  UINavigationBar.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/16/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

extension UINavigationBar {

    func set(bottomBorderColor color: UIColor, height: CGFloat) {
        let bottomBorderView = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: height))
        bottomBorderView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        bottomBorderView.backgroundColor = color

        self.addSubview(bottomBorderView)
    }

}
