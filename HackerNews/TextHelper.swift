//
//  TextHelper.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/19/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

class TextHelper {

    static func text(commentButtonWithString string: String) -> NSAttributedString {
        let attributedString = IonIcon.subtitleIcon(type: .ion_chatbox)
        attributedString.append(NSAttributedString(
            string: string,
            attributes: Styles.storyBar.button))

        return attributedString
    }

    static func text(shareButtonWithString string: String) -> NSAttributedString {
        let attributedString = IonIcon.subtitleIcon(type: .ion_ios_upload)
        attributedString.append(NSAttributedString(
            string: string,
            attributes: Styles.storyBar.button))

        return attributedString
    }

    static func text(voteButtonWithString string: String) -> NSAttributedString {
        let attributedString = IonIcon.subtitleIcon(type: .ion_arrow_up_a)
        attributedString.append(NSAttributedString(
            string: string,
            attributes: Styles.storyBar.button))

        return attributedString
    }

    static func text(replyButtonWithString string: String) -> NSAttributedString {
        let attributedString = IonIcon.subtitleIcon(type: .ion_reply)
        attributedString.append(NSAttributedString(
            string: string,
            attributes: Styles.storyBar.button))

        return attributedString
    }

    static func text(moreButtonWithString string: String) -> NSAttributedString {
        let attributedString = IonIcon.subtitleIcon(type: .ion_more)
        attributedString.append(NSAttributedString(
            string: string,
            attributes: Styles.storyBar.button))

        return attributedString
    }

}
