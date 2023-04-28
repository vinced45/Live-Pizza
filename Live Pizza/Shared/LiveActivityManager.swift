//
//  LiveActivityManager.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation

import Foundation
import ActivityKit
import Combine
import SwiftUI

class LiveActivityManager: NSObject, ObservableObject {
    public static let shared = LiveActivityManager()
    private override init() {
        super.init()
    }

    @Published public var isActivityActive: Bool = false
    @Published public var pushToken: String?
}

// MARK: - Public Methods
extension LiveActivityManager {
    func checkForLiveActivities() {
        if #available(iOS 16.2, *) {
            log(event: .checkForLiveActivities)
            if let activity = getActivity() {
                log(event: .liveActivityFound, value: activity.id)
                setupListeners(for: activity)
            } else {
                log(event: .liveActivityNotFound)
            }
        }
    }

    func startLiveActivity(for pizza: Pizzable, from type: UpdateType = .cloud) {
        if #available(iOS 16.2, *) {
            guard canPerformLiveActivities() else { return }
            guard isLiveActivityEligible(for: pizza) else {
                return
            }
            guard noCurrentActivity() else {
                updateLiveActivity(for: pizza)
                return
            }

            do {
                let activity = try Activity<PizzaResultsAttributes>.request(
                    attributes: pizza.attributes,
                    content: .init(
                        state: pizza.contentState(type: type),
                        staleDate: Date().addingTimeInterval(60)
                    ),
                    pushType: .token
                )
                log(event: .liveActivityStarted, value: activity.id)
                setupListeners(for: activity)
            } catch {
                log(event: .liveActivityStartError, value: error.localizedDescription)
            }
        }
    }

    func updateLiveActivity(for pizza: Pizzable, from type: UpdateType = .cloud) {
        if #available(iOS 16.2, *) {
            guard let activity = getActivity() else {
                startLiveActivity(for: pizza)
                return
            }
            guard canPerformLiveActivities() else { return }

            Task {
                var alert: AlertConfiguration?
                alert = AlertConfiguration(title: "\(activity.content.state.leader?.name ?? "") is the leader!",
                                           body: "They currently have \(activity.content.state.leader?.votes ?? 0) votes!",
                                           sound: .default)
                await activity.update(using: pizza.contentState(type: type), alertConfiguration: alert)
                log(event: .liveActivityUpdated, value: activity.id)
            }
            setupListeners(for: activity)
        }
    }

    func endLiveActivity(for pizza: Pizzable) {
        if #available(iOS 16.2, *) {
            guard let activity = getActivity(),
                  canPerformLiveActivities() else { return }
            Task {
                await activity.end(
                    .init(
                        state: pizza.contentState(),
                        staleDate: nil
                    ),
                    dismissalPolicy: .immediate
                )
                pushToken = nil
                isActivityActive = false
                log(event: .liveActivityEnded, value: activity.id)
                await checkIfActive(for: activity)
            }
        }
    }


    func updateLiveActivityUI(for type: LiveActivityType) {
        if #available(iOS 16.2, *) {
            guard let activity = getActivity(type) else {
                log(event: .liveActivityUIRefreshedNoActivity)
                return
            }

            Task {
                await activity.update(using: activity.content.state.contentState(type: .refresh), alertConfiguration: nil)
                log(event: .liveActivityUIRefreshedUpdated, value: activity.id)
            }
            setupListeners(for: activity)
        }
    }

    var refreshDate: Date {
        if #available(iOS 16.2, *) {
            let twoMinutes = Date(timeIntervalSinceNow: 120) // Refresh every 2 minutes
            guard let _ = getActivity() else {
                return .distantFuture
            }

            return twoMinutes
        }
        return .distantFuture
    }
}

// MARK: - Private Methods
extension LiveActivityManager {
    @available(iOS 16.2, *)
    private func getActivity(_ type: LiveActivityType = .votes) -> Activity<PizzaResultsAttributes>? {
        guard let activity = Activity<PizzaResultsAttributes>.activities.first(where: { $0.attributes.type == type }) else { return nil }
        return activity
    }

    @available(iOS 16.2, *)
    private func noCurrentActivity() -> Bool {
        return getActivity() == nil
    }

    @available(iOS 16.2, *)
    private func canPerformLiveActivities() -> Bool {
        let auth = ActivityAuthorizationInfo()
        log(event: .liveActivityAuthStateChange, value: "\(auth.areActivitiesEnabled)")
        return auth.areActivitiesEnabled
    }

    @available(iOS 16.2, *)
    private func checkIfActive(for activity: Activity<PizzaResultsAttributes>) async {
        for await activityState in activity.activityStateUpdates {
            self.isActivityActive = activityState == .active
            log(event: .liveActivityStateChange, value: "\(activityState)")
            if activityState == .dismissed {
                self.pushToken = nil
                self.isActivityActive = false
            }
        }
    }

    @available(iOS 16.2, *)
    private func listenForChanges(for activity: Activity<PizzaResultsAttributes>) async {
        for await _ in activity.contentUpdates {
            log(event: .liveActivityListenerSetup, value: Date().formatted())
        }
    }

    @available(iOS 16.2, *)
    private func listenForPushTokens(for activity: Activity<PizzaResultsAttributes>) async {
        for await push in activity.pushTokenUpdates {
            let token = push.map { String(format: "%02x", $0) }.joined()
            if !token.elementsEqual(self.pushToken ?? "") {
                self.pushToken = token
                log(event: .liveActivityTokenChanged, value: token)
            }
        }
    }

    @available(iOS 16.2, *)
    private func setupListeners(for activity: Activity<PizzaResultsAttributes>) {
        Task {
            await listenForChanges(for: activity)
        }
        Task {
            await listenForPushTokens(for: activity)
        }
        Task {
            await checkIfActive(for: activity)
        }
        log(event: .liveActivityListenerSetup)
    }

    private func endLiveActivity() {
        if #available(iOS 16.2, *) {
            guard let activity = getActivity(),
                  canPerformLiveActivities() else { return }
            let currentFlightContent = activity.content.state
            Task {
                await activity.end(
                    .init(
                        state: currentFlightContent,
                        staleDate: nil
                    ),
                    dismissalPolicy: .immediate
                )
                pushToken = nil
                isActivityActive = false
                log(event: .liveActivityEnded, value: "\(activity.id)")
                await checkIfActive(for: activity)
            }
        }
    }
}

// MARK: - Eligibility
private extension LiveActivityManager {
    func isLiveActivityEligible(for pizza: Pizzable) -> Bool {
        if #available(iOS 16.2, *) {
            return true
        } else {
            return false
        }
    }
}

// MARK: - QM Methods
extension LiveActivityManager {
    func log(event: LiveActivityEvent, value: String? = nil, forceQMEvent: Bool = false) {
        #if DEBUG
            if let logValue = value {
                print("⚡ Live Activity - \(event.rawValue) : \(logValue)")
            } else {
                print("⚡ Live Activity - \(event.rawValue)")
            }
        #else
            // FIXME: Have this go to your actual Analytics SDK
        #endif
    }
}
