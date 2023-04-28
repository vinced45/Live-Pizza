//
// Copyright © 2023 United Airlines. All rights reserved.
//

import Foundation
import BackgroundTasks
import SwiftUI

class BackgroundTaskHelper {
    static let shared = BackgroundTaskHelper()
    private init() {}

    func registerBackgroundRefresh() {
        let success = BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.backgroundTaskID,
                                                      using: nil,
                                                      launchHandler: { task in
            BackgroundTaskHelper.shared.handleLiveActivity(with: task as! BGAppRefreshTask)
        })
        let event: LiveActivityEvent = success ? .liveActivityUIRefreshedRegistered : .liveActivityUIRefreshedFailedToRegister
        let timeLeft = success ? "Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s" : ""
        LiveActivityManager.shared.log(event: event, value: timeLeft)
    }

    func scheduleLiveActivityRefresh() {
        switch UIApplication.shared.backgroundRefreshStatus {
        case .available:
            break
        default:
            LiveActivityManager.shared.log(event: .liveActivityUIRefreshedDenied)
            return
        }
        let request = BGAppRefreshTaskRequest(identifier: Constants.backgroundTaskID)
        request.earliestBeginDate = LiveActivityManager.shared.refreshDate
        do {
            try BGTaskScheduler.shared.submit(request)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            let refreshDate = formatter.string(from: LiveActivityManager.shared.refreshDate)
            LiveActivityManager.shared.log(event: .liveActivityUIRefreshedEnabled, value: "next refreash: \(refreshDate)")
        } catch {
            LiveActivityManager.shared.log(event: .liveActivityUIRefreshedError, value: error.localizedDescription)
        }
    }

    func handleLiveActivity(with task: BGAppRefreshTask) {
        LiveActivityManager.shared.updateLiveActivityUI(for: .votes)
        LiveActivityManager.shared.log(event: .liveActivityUIRefreshedFromBackground)
        task.expirationHandler = {
            LiveActivityManager.shared.log(event: .liveActivityUIRefreshedExpired)
        }
        BackgroundTaskHelper.shared.scheduleLiveActivityRefresh()
        task.setTaskCompleted(success: true)
    }
}
