//
//  HNSearchProtocol.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/3/17.
//  Copyright © 2017 Null. All rights reserved.
//

import UIKit

protocol HNSearchProtocol {

    var query: String { get set }
    var sortType: SearchSortType { get set }
    var timeRangeType: SearchTimeRangeType { get set }

    func onRefreshNotificationReceived(notification: Notification)

    func refresh(refreshControl: UIRefreshControl?)

    func fetchMoreItems(completion: ((Bool) -> ())?)

}
