//
//  NSMutableAttributedString.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/24/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    func detectLinks() -> NSMutableAttributedString {
        do {
            let urlDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

            urlDetector.enumerateMatches(in: self.string, options: [], range: NSMakeRange(0, self.string.characters.count)) { (result, flags, stop) in

                if let result = result {
                    if result.resultType == .link {
                        if let absoluteString = result.url?.absoluteString {
                            var attributes = Styles.others.link
                            attributes[Constants.kTextLinkAttributeName] = NSURL(string: absoluteString)
                            self.addAttributes(attributes, range: result.range)
                        }
                    }
                }
            }
        } catch let error {
            print(error)
        }

        return self
    }

}
