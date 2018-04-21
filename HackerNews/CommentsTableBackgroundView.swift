//
//  CommentsTableBackgroundView.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 12/4/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

class CommentsTableBackgroundView: UIView {

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        let width = UIScreen.main.bounds.height // get the height because of landscape

        for i in 1..<(Int(floor(width / HNDimensions.comments.paddingPerLevel))) {
            let divider = UIView(frame: CGRect(x: CGFloat(i) * HNDimensions.comments.paddingPerLevel, y: 0, width: 1, height: 0))
            divider.backgroundColor = Styles.comment.divider
            divider.autoresizingMask = [.flexibleHeight]
            self.addSubview(divider)
        }
    }

}
