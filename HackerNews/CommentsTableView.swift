//
//  CommentsTableView.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/23/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class CommentsTableView: ASTableNode {

    // MARK: - Properties

    var selectedIndexPaths: [IndexPath] = []
    var collapsedIndexPaths: [IndexPath] = []

    // MARK: - Lifecycle

    init() {
        super.init(style: .plain)

        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
//        self.setupBackView()
        self.setupTableView()
        self.setupTheme()
    }

    func setupTableView() {
        self.view.separatorStyle = .none
        self.view.separatorInset = UIEdgeInsets.zero
        self.view.tableFooterView = UIView()
        self.view.alwaysBounceVertical = true
        self.view.layoutMargins = UIEdgeInsets.zero
        self.allowsMultipleSelection = true
        self.clipsToBounds = true
        self.view.backgroundView?.clipsToBounds = true
    }

    func setupBackView() {
        let backView = UIView(frame: UIScreen.main.bounds)

        for i in 1..<(Int(floor(UIScreen.main.bounds.width / HNDimensions.comments.paddingPerLevel))) {
            let divider = UIView(frame: CGRect(x: CGFloat(i) * HNDimensions.comments.paddingPerLevel, y: 0, width: 1, height: UIScreen.main.bounds.height))
            divider.backgroundColor = Styles.comment.divider
            backView.addSubview(divider)
        }

        self.view.backgroundView = backView
    }

}
