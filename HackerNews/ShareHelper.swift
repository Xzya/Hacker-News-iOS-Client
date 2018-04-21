//
//  ShareHelper.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/10/16.
//  Copyright © 2016 Null. All rights reserved.
//

import UIKit

class ShareHelper {

    static func share(items: [Any], fromViewController viewController: UIViewController, sourceView: UIView?) {
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
            activityVC.popoverPresentationController?.sourceView = sourceView ?? viewController.view
            activityVC.popoverPresentationController?.sourceRect = activityVC.popoverPresentationController?.sourceView?.bounds ?? CGRect.zero
        }
        viewController.present(activityVC, animated: true, completion: nil)
    }

}
