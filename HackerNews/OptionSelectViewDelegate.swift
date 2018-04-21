//
//  OptionSelectViewDelegate.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/21/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol OptionSelectViewDelegate {
    func optionSelectView(optionSelectView: OptionsViewController, numberOfItemsInSection section: Int) -> Int
    func numberOfSections(in optionSelectView: OptionsViewController) -> Int
    func optionSelectView(optionSelectView: OptionsViewController, didSelectItemAtIndexPath indexPath: IndexPath)
    func optionSelectView(optionSelectView: OptionsViewController, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock
    func optionSelectView(optionSelectView: OptionsViewController, viewForHeaderInSection section: Int) -> UIView?
    func optionSelectView(optionSelectView: OptionsViewController, heightForHeaderInSection section: Int) -> CGFloat
}

extension OptionSelectViewDelegate {
    func optionSelectView(optionSelectView: OptionsViewController, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func optionSelectView(optionSelectView: OptionsViewController, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
