//
//  HNPagerViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/2/17.
//  Copyright © 2017 Null. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HNPagerViewController: ButtonBarPagerTabStripViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        self.setupPager()

        super.viewDidLoad()
    }

    // MARK: - Setup Helpers

    func setupPager() {
        self.settings.style.buttonBarBackgroundColor = Styles.pager.buttonBarBackground
        self.settings.style.buttonBarItemBackgroundColor = Styles.pager.buttonBarItemBackground
        self.settings.style.selectedBarBackgroundColor = Styles.pager.selectedBarBackground
        self.settings.style.buttonBarItemFont = Styles.pager.buttonBarItemFont
        self.settings.style.selectedBarHeight = 1.5
        self.settings.style.buttonBarMinimumLineSpacing = 0
        self.settings.style.buttonBarItemTitleColor = Styles.pager.buttonBarItemTitleSelected
        self.settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        self.settings.style.buttonBarLeftContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0

        self.changeCurrentIndex = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, animated: Bool) -> Void in

            oldCell?.label.textColor = Styles.pager.buttonBarItemTitle
            newCell?.label.textColor = Styles.pager.buttonBarItemTitleSelected
        }

        self.pagerBehaviour = .common(skipIntermediateViewControllers: true)
    }

}
