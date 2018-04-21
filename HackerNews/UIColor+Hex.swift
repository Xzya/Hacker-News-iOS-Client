//
//  UIColor+Hex.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/1/17.
//  Copyright © 2017 Null. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}
