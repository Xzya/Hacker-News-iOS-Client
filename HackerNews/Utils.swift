//
//  Utils.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

class Utils {

    static func nibName(forClassType type: AnyClass) -> String {
        return type.description().components(separatedBy: ".").last ?? ""
    }

    static func nib(forClassType type: AnyClass) -> UINib {
        return UINib.init(nibName: Utils.nibName(forClassType: type), bundle: nil)
    }

    static func loadNib(forClassType type: AnyClass) -> Any? {
        return Bundle.main.loadNibNamed(Utils.nibName(forClassType: type), owner: nil, options: nil)?.first
    }

    static func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.openURL(url)
        }
    }

    static func copy(string: String) {
        UIPasteboard.general.string = string
    }

}
