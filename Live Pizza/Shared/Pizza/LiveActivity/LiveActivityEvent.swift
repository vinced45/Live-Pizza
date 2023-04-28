//
//  LiveActivityEvent.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation

public enum LiveActivityEvent: String {
    case checkForLiveActivities
    case liveActivityFound
    case liveActivityNotFound
    case liveActivityStarted
    case liveActivityStartError
    case liveActivityUpdated
    case liveActivityEnded
    case liveActivityRecreateError
    case liveActivityAuthStateChange
    case liveActivityStateChange
    case liveActivityListenerSetup
    case liveActivityTokenChanged
    case liveActivitySubscriptionSuccess
    case liveActivitySubscriptionFail
    case liveActivityBoardingPassButtonTapped
    case liveActivityFlightStatusButtonTapped
    case liveActivityIrropButtonTapped
    case liveActivityUIRefreshedUpdated
    case liveActivityUIRefreshedFromBackground
    case liveActivityUIRefreshedEnteredBackground
    case liveActivityUIRefreshedDenied
    case liveActivityUIRefreshedEnabled
    case liveActivityUIRefreshedError
    case liveActivityUIRefreshedExpired
    case liveActivityUIRefreshedRegistered
    case liveActivityUIRefreshedFailedToRegister
    case liveActivityUIRefreshedNoActivity
}
