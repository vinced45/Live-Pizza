//
//  AppIntentHelper.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation
import AppIntents
import SwiftUI
import ActivityKit


struct UAIntentShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: PizzaIntent(),
            phrases: ["\(.applicationName) voting",
                      "\(.applicationName) voting results",
                      "Voting results for \(.applicationName)",
                      "Voting for \(.applicationName)"],
            systemImageName: "checklist"
        )
    }
}

struct PizzaIntent: AppIntent, LiveActivityStartingIntent {
    static let title: LocalizedStringResource = "Pizza"

    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView & ReturnsValue<PizzaResultsEntity>  {
        if let context = await UserDefaultsHelper.getPizzaResults() {
            let pizza = PizzaResultsEntity(context: context)
            LiveActivityManager.shared.startLiveActivity(for: context)
            return .result(
                value: pizza,
                dialog: IntentDialog(stringLiteral: context.dialog),
                view: PizzaVoteView(results: context, style: .siri)
            )
        } else {
            let pizza = PizzaResultsEntity(context: PizzaResults.empty)
            return .result(
                value: pizza,
                dialog: "We don't have any votes yet",
                view: EmptyView()
            )
        }
    }
    
    func retrievePizzaContext() async -> Pizza? {
        if let userDefaults = UserDefaults(suiteName: Constants.appGroup),
           let dataObject = userDefaults.object(forKey: "pizza") as? Data,
           let pizza = try? JSONDecoder().decode(Pizza.self, from: dataObject) {
            return pizza
        } else {
            return nil
        }
    }
}

struct PizzaResultsEntity: AppEntity {
    var id: UUID = UUID()
    
    @Property(title: "Restaurant")
    var restaurant: String
    
    @Property(title: "Votes")
    var votes: Int

    @Property(title: "Details")
    var details: String

    @Property(title: "Image")
    var image: String
    
    @Property(title: "URL")
    var url: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: "Pizza Vote Leader")
    }

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Pizza")
    
    static var defaultQuery: PizzaResultsQuery = PizzaResultsQuery()

    init(context: PizzaResults) {
        self.restaurant = context.leader?.name ?? ""
        self.votes = context.leader?.votes ?? 0
        self.details = context.leader?.details ?? ""
        self.image = context.leader?.image ?? ""
        self.url = context.leader?.url ?? ""
    }
}

struct PizzaResultsQuery: EntityQuery {
    func entities(for identifiers: [PizzaResultsEntity.ID]) async throws -> [PizzaResultsEntity] {
        return []
    }

    func suggestedEntities() async throws -> [PizzaResultsEntity] {
       return []
    }
}
