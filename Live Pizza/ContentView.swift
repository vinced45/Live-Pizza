//
//  ContentView.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import SwiftUI
import AppIntents

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var cloudService = CloudKitService()
    @StateObject var liveActivity = LiveActivityManager.shared
    
    @State var currentPizza: Pizza = PizzaType.giordanos.pizza()
    @State var showSheet: Bool = false
    @State var showAboutMe: Bool = false
    
    @AppStorage("accessibility", store: UserDefaults(suiteName: Constants.appGroup))
    var enableAccessibility: Bool = true
    
    @AppStorage("dynamicText", store: UserDefaults(suiteName: Constants.appGroup))
    var enableDynamicText: Bool = true
    
    let pizzas: [Pizza] = PizzaType.allCases.map({ $0.pizza() })
    
    var body: some View {
        NavigationStack {
            Form {
                pizzaSelectionView
                
                pizzaVotingResultsView
                
                sectionButton(name: "Show Pizza Details", color: .mediumBrown, action: togglePizza)
                
                votingView
                
                liveActivityView
                
                accessibilityView
                
                dynamicTextView
            }
            .navigationTitle("Favorite Deep Dish 🍕")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAboutMe.toggle()
                    }, label: {
                        Image(systemName: "info.circle")
                            .font(.title3)
                    })
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.mediumBrown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .refreshable {
                await cloudService.reload()
            }
            .task {
                await cloudService.fetchAccountStatus()
                await cloudService.subscribeForPushNotifications()
                await cloudService.checkIfVoted()
                await cloudService.fetchPizzaResults()
            }
            .sheet(isPresented: $showSheet) {
                PizzaDetailView(pizza: currentPizza)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showAboutMe) {
                AboutMeView()
                    .presentationDetents([.large])
            }
            .onOpenURL(perform: { url in
                if let params = url.queryParameters,
                   let pizzaId = Int(params["pizza"]!),
                   let pizza = PizzaType(rawValue: pizzaId)?.pizza() {
                    currentPizza = pizza
                    showSheet = true
                }
            })
        }
    }
}

// MARK: - Subviews
extension ContentView {
    var pizzaSelectionView: some View {
        Section(content: {
            Picker("Select a Pizza", selection: $currentPizza) {
                ForEach(pizzas) { pizza in
                    Text(pizza.name).tag(pizza)
                }
            }
        }, header: {
            Text("Pizzas 🍕")
        }, footer: {
            VStack {
                if cloudService.votedAlready {
                    HStack {
                        Spacer()
                        VStack(spacing: 0) {
                            Text("You already voted for \(cloudService.vote?.name ?? "").")
                            Text("Tap 'Clear Vote' button below to change your vote.")
                        }
                        Spacer()
                    }
                }
                SiriTipView(intent: PizzaIntent())
                    .siriTipViewStyle(colorScheme == .dark ? .light : .dark)
                    .padding(.top)
            }
        })
    }
    
    var pizzaVotingResultsView: some View {
        if let results = cloudService.pizzaResults {
            return AnyView(Section {
                PizzaVoteView(results: results, style: .inApp)
            })
        }
        return AnyView(EmptyView())
    }
    
    func sectionButton(name: String, color: Color, action: @escaping () -> Void) -> some View {
        Section {
            Button(action: {
                action()
            }, label: {
                HStack {
                    Spacer()
                    Text(name).foregroundColor(.white)
                    Spacer()
                }
            })
            .listRowBackground(color)
        }
    }
    
    var votingView: some View {
        if cloudService.votedAlready {
            return sectionButton(name: "Clear Vote", color: .darkBrown, action: delete)
        } else {
            return sectionButton(name: "Vote", color: .pizzaYellow, action: vote)
        }
    }
    
    var liveActivityView: some View {
        if liveActivity.isActivityActive {
            return sectionButton(name: "End Live Activity", color: .darkBrown, action: endLiveActivity)
        } else {
            return sectionButton(name: "Start Live Activity", color: .pizzaYellow, action: startLiveActivity)
        }
    }
    
    var accessibilityView: some View {
        Section(content: {
            Toggle("Enable Accessibility", isOn: $enableAccessibility)
        }, header: {
            Text("Accessibility")
        }, footer: {
            Text("Enable Voice Over to see the difference when this is enabled or not.")
        })
    }
    
    var dynamicTextView: some View {
        Section(content: {
            Toggle("Enable Dynamic Text", isOn: $enableDynamicText)
        }, header: {
            Text("Dynamic Text")
        }, footer: {
            Text("Go to Control Center and change text size to see the effects of this being enabled")
        })
    }
}

// MARK: - Methods
extension ContentView {
    func togglePizza() {
        showSheet.toggle()
    }
    
    func vote() {
        Task {
            await cloudService.saveVote(for: currentPizza)
            guard let results = cloudService.pizzaResults else { return }
            liveActivity.updateLiveActivity(for: results, from: .device)
        }
    }
    
    func delete() {
        Task {
            await cloudService.delete()
            guard let results = cloudService.pizzaResults else { return }
            liveActivity.updateLiveActivity(for: results, from: .device)
        }
    }
    
    func startLiveActivity() {
        Task {
            await cloudService.fetchPizzaResults()
            guard let results = cloudService.pizzaResults else { return }
            liveActivity.startLiveActivity(for: results, from: .device)
        }
    }
    
    func endLiveActivity() {
        Task {
            await cloudService.fetchPizzaResults()
            guard let results = cloudService.pizzaResults else { return }
            liveActivity.endLiveActivity(for: results)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
