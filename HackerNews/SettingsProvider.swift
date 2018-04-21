//
//  SettingsProvider.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/30/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import PINCache

class SettingsProvider {

    static func get(ofType type: SettingsType) -> Any? {
        return PINCache.shared.object(forKey: type.value)
    }

    static func set(value: String, forType type: SettingsType) {
        PINCache.shared.setObject(value as NSCoding, forKey: type.value)
    }

    static var storyType: StoryType {
        get {
            return StoryType.initWithValue(value: (self.get(ofType: .defaultStoryType) as? String ?? "")) ?? .top
        }
        set {
            self.set(value: newValue.value, forType: .defaultStoryType)
        }
    }

    static var font: FontType {
        get {
            return FontType.initWithValue(value: (self.get(ofType: .font) as? String ?? "")) ?? .default
        }
        set {
            self.set(value: newValue.value, forType: .font)

            FontManager.set(fontType: newValue, andSizeType: self.fontSize)
        }
    }

    static var fontSize: FontSizeType {
        get {
            return FontSizeType.initWithValue(value: (self.get(ofType: .fontSize) as? String ?? "")) ?? .default
        }
        set {
            self.set(value: newValue.value, forType: .fontSize)

            FontManager.set(fontType: self.font, andSizeType: newValue)
        }
    }

    static var theme: ThemeType {
        get {
            return ThemeType.initWithValue(value: (self.get(ofType: .theme) as? String ?? "")) ?? .dark
        }
        set {
            self.set(value: newValue.value, forType: .theme)

            ThemeManager.set(themeType: newValue)
        }
    }

}
