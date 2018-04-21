//
//  String.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/12/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

extension String {

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    init(htmlEncodedString: String) {
        self.init()

        // new method
        if let parsedString = htmlEncodedString.htmlAttributedString()?.string {
            self = parsedString
            return
        }

        // old method
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }

        let attributedOptions: [String : Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]

        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }

    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil) else { return nil }
        return html
    }

    func domainName() -> String {
        var domain: String = self

        if self.range(of: "://") != nil {
            domain = self.components(separatedBy: "/")[2]
        } else {
            domain = self.components(separatedBy: "/")[0]
        }

        domain = domain.components(separatedBy: ":")[0]

        return domain
    }

    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

}

extension String {
    static private let mappings = ["&quot;" : "\"","&amp;" : "&", "&lt;" : "<", "&gt;" : ">","&nbsp;" : " ","&iexcl;" : "¡","&cent;" : "¢","&pound;" : " £","&curren;" : "¤","&yen;" : "¥","&brvbar;" : "¦","&sect;" : "§","&uml;" : "¨","&copy;" : "©","&ordf;" : " ª","&laquo" : "«","&not" : "¬","&reg" : "®","&macr" : "¯","&deg" : "°","&plusmn" : "±","&sup2; " : "²","&sup3" : "³","&acute" : "´","&micro" : "µ","&para" : "¶","&middot" : "·","&cedil" : "¸","&sup1" : "¹","&ordm" : "º","&raquo" : "»&","frac14" : "¼","&frac12" : "½","&frac34" : "¾","&iquest" : "¿","&times" : "×","&divide" : "÷","&ETH" : "Ð","&eth" : "ð","&THORN" : "Þ","&thorn" : "þ","&AElig" : "Æ","&aelig" : "æ","&OElig" : "Œ","&oelig" : "œ","&Aring" : "Å","&Oslash" : "Ø","&Ccedil" : "Ç","&ccedil" : "ç","&szlig" : "ß","&Ntilde;" : "Ñ","&ntilde;":"ñ",]

    func stringByDecodingXMLEntities() -> String {

        guard let _ = self.range(of: "&", options: [.literal]) else {
            return self
        }

        var result = ""

        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil

        let boundaryCharacterSet = CharacterSet(charactersIn: " \t\n\r;")

        repeat {
            var nonEntityString: NSString? = nil

            if scanner.scanUpTo("&", into: &nonEntityString) {
                if let s = nonEntityString as? String {
                    result.append(s)
                }
            }

            if scanner.isAtEnd {
                break
            }

            var didBreak = false
            for (k,v) in String.mappings {
                if scanner.scanString(k, into: nil) {
                    result.append(v)
                    didBreak = true
                    break
                }
            }

            if !didBreak {

                if scanner.scanString("&#", into: nil) {

                    var gotNumber = false
                    var charCodeUInt: UInt32 = 0
                    var charCodeInt: Int32 = -1
                    var xForHex: NSString? = nil

                    if scanner.scanString("x", into: &xForHex) {
                        gotNumber = scanner.scanHexInt32(&charCodeUInt)
                    }
                    else {
                        gotNumber = scanner.scanInt32(&charCodeInt)
                    }

                    if gotNumber {
                        let newChar = String(format: "%C", (charCodeInt > -1) ? charCodeInt : charCodeUInt)
                        result.append(newChar)
                        scanner.scanString(";", into: nil)
                    }
                    else {
                        var unknownEntity: NSString? = nil
                        scanner.scanUpToCharacters(from: boundaryCharacterSet, into: &unknownEntity)
                        let h = xForHex ?? ""
                        let u = unknownEntity ?? ""
                        result.append("&#\(h)\(u)")
                    }
                }
                else {
                    scanner.scanString("&", into: nil)
                    result.append("&")
                }
            }
            
        } while (!scanner.isAtEnd)
        
        return result
    }
}

extension String {
    static private let htmlMappings = [
        "<p></p>": "",
        "<p>": "\n",
        "</p>": "\n",
        "<i>": "",
        "</i>": "",
        "</a>": "",
        "<pre>": "",
        "</pre>": "",
        "<code>": "/> ",
        "</code>": "",
    ]

    func stringByRemovingHTMLTags() -> String {

        guard let _ = self.range(of: "<", options: [.literal]) else {
            return self
        }

        var result = ""

        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil

        repeat {

            var nonEntityString: NSString? = nil

            if scanner.scanUpTo("<", into: &nonEntityString) {
                if let s = nonEntityString as? String {
                    result.append(s)
                }
            }

            if scanner.isAtEnd {
                break
            }

            var didBreak = false
            for (k,v) in String.htmlMappings {
                if scanner.scanString(k, into: nil) {
                    result.append(v)
                    didBreak = true
                    break
                }
            }

            if !didBreak {

                // check if the current character is a <a> tag
                if scanner.scanString("<a", into: nil) {

                    // scan until we find an href
                    if scanner.scanUpTo("href=\"", into: nil) {

                        // scan the href
                        if scanner.scanString("href=\"", into: nil) {

                            var href: NSString? = nil

                            // scan the href value
                            if scanner.scanUpTo("\"", into: &href) {
                                if let s = href as? String {
                                    result.append(s)
                                }
                            }
                        }
                    }

                    // scan until we find the closing tag
                    scanner.scanUpTo("</a>", into: nil)
                } else {
                    scanner.scanString("<", into: nil)
                    result.append("<")
                }
            }

        } while (!scanner.isAtEnd)

        while result.characters.first == "\n" {
            result.remove(at: result.startIndex)
        }

        while result.characters.last == "\n" {
            result.remove(at: result.index(before: result.endIndex))
        }

        return result
    }
}

extension String {
    /**
     * Returns the fnid if it is found in the string. The fnid is
     * used when submitting a post.
     */
    func getFnid() -> String? {

        // define the fnid selector
        let entityName = "name=\"fnid\" value=\""

        // make sure the string contains it
        guard let _ = self.range(of: entityName, options: [.literal]) else {
            return nil
        }

        // create a scanner
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil

        // scan up to the entity name
        scanner.scanUpTo(entityName, into: nil)

        // jump over the entity name
        scanner.scanLocation += entityName.characters.count

        var result: NSString? = nil

        // scan the entity
        if scanner.scanUpTo("\"", into: &result) {
            return result as? String
        }
        
        return nil
    }

    /**
     * Returns the hmac if it is found in the string. The hmac is
     * used when confirming an item deletion.
     */
    func getHmac() -> String? {

        // define the fnid selector
        let entityName = "name=\"hmac\" value=\""

        // make sure the string contains it
        guard let _ = self.range(of: entityName, options: [.literal]) else {
            return nil
        }

        // create a scanner
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil

        // scan up to the entity name
        scanner.scanUpTo(entityName, into: nil)

        // jump over the entity name
        scanner.scanLocation += entityName.characters.count

        var result: NSString? = nil

        // scan the entity
        if scanner.scanUpTo("\"", into: &result) {
            return result as? String
        }
        
        return nil
    }

    func isSubmittingTooFast() -> Bool {
        // define the selector
        let entityName = "submitting too fast"

        // make sure the string contains it
        guard let _ = self.range(of: entityName, options: [.literal]) else {
            return false
        }
        return true
    }

    func isDuplicate() -> Bool {
        // define the selector
        let entityName = "item?id="

        // make sure the string contains it
        guard let _ = self.range(of: entityName, options: [.literal]) else {
            return false
        }
        return true
    }

    func hasNewestPage() -> Bool {
        // define the selector
        let entityName = "://news.ycombinator.com/newest"

        // make sure the string contains it
        guard let _ = self.range(of: entityName, options: [.literal]) else {
            return false
        }
        return true
    }
}

/**
 * Validators
 */
extension String {

    func isValidUrl() -> Bool {
        if let _ = URL(string: self) {
            return true
        }
        return false
    }

}
