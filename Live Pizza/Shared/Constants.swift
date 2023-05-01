//
//  Constants.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation

struct Constants {
    static let appGroup = "group.com.deepdishswift.Live-Pizza"
    static let cloudContainer = "iCloud.com.deepdishswift.Live-Pizza"
    static let resultsDefaultsKey = "pizzaResults"
    static let subscriptionID = "results.update"
    static let deepLinkScheme = "deepdish"
    static let backgroundTaskID = "updateLiveActivityUI"
    static var talkEndDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2023/05/02 13:35")!
    }
    static var progressStartDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2023/04/30 10:00")!
    }
}
