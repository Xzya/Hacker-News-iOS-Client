//
//  FontManager.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/19/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

class Font {

    static let kIconSizeOffset: CGFloat = 4

    var titleSize: CGFloat = 17
    var textSize: CGFloat = 15
    var subtitleSize: CGFloat = 11

    var titleFont: UIFont
    var textFont: UIFont
    var subtitleFont: UIFont

    var titleIconFont: UIFont
    var textIconFont: UIFont
    var subtitleIconFont: UIFont

    init(fontName: String, offset: CGFloat) {
        self.titleSize += offset
        self.textSize += offset
        self.subtitleSize += offset

        if let titleFont = UIFont(name: fontName, size: self.titleSize) {
            self.titleFont = titleFont
        } else {
            self.titleFont = UIFont.systemFont(ofSize: self.titleSize)
        }

        if let textFont = UIFont(name: fontName, size: self.textSize) {
            self.textFont = textFont
        } else {
            self.textFont = UIFont.systemFont(ofSize: self.textSize)
        }

        if let subtitleFont = UIFont(name: fontName, size: self.subtitleSize) {
            self.subtitleFont = subtitleFont
        } else {
            self.subtitleFont = UIFont.systemFont(ofSize: self.subtitleSize)
        }

        self.titleIconFont = UIFont.ionIconFont(ofSize: self.titleSize + Font.kIconSizeOffset)
        self.textIconFont = UIFont.ionIconFont(ofSize: self.textSize + Font.kIconSizeOffset)
        self.subtitleIconFont = UIFont.ionIconFont(ofSize: self.subtitleSize + Font.kIconSizeOffset)
    }

    static let normal: Font = {
        return Font(fontName: UIFont.systemFont(ofSize: 1).fontName, offset: 1)
    }()

}

class FontManager {

    static var currentFont: Font = {
        return FontManager.get(ofFontType: SettingsProvider.font, andSizeType: SettingsProvider.fontSize)
    }()

    static func set(font: Font) {
        self.currentFont = font
    }

    static func get(ofFontType type: FontType, andSizeType sizeType: FontSizeType) -> Font {
        var fontName = ""
        var fontOffset: CGFloat = 1

        switch type {
        case .default:
            fontName = UIFont.systemFont(ofSize: 1).fontName
        default:
            fontName = type.title
        }

        switch sizeType {
        case .smallest:
            fontOffset = -2
        case .small:
            fontOffset = -1
        case .default:
            fontOffset = 1
        case .large:
            fontOffset = 4
        case .largest:
            fontOffset = 6
        }

        return Font(fontName: fontName, offset: fontOffset)
    }

    static func set(fontType type: FontType, andSizeType sizeType: FontSizeType) {
        self.set(font: self.get(ofFontType: type, andSizeType: sizeType))
    }

}
