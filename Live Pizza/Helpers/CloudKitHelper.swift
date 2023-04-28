//
//  CloudKitHelper.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/23/23.
//

import Foundation
import CloudKit

enum CloudKitError: Error {
    case unableToGetAccountStatus
    case unableToSaveRecord
    case unableToDeleteRecord
    case unableToFetchRecord
    case unableToGetUserName
    case unableToSubscribe
    case unableToFetchAll
}

@MainActor
class CloudKitService: ObservableObject {
    let container: CKContainer = CKContainer(identifier: Constants.cloudContainer)
    
    init() {}
    
    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
    @Published private(set) var userID: CKRecord.ID?
    @Published var isSaving: Bool = false
    @Published var votedAlready: Bool = false
    @Published var vote: PizzaVote?
    @Published var pizzaResults: PizzaResults?
    
    private var currentCloudRecord: CKRecord?
    
    // MARK: - Public Methods
    func reload() async {
        do {
            await fetchAccountStatus()
            await checkIfVoted()
            await fetchPizzaResults()
            guard let results = pizzaResults else { return }
            LiveActivityManager.shared.updateLiveActivity(for: results, from: .device)
        }
    }
    
    func fetchAccountStatus() async {
        do {
            accountStatus = try await checkAccountStatus()
            userID = try await getUserID()
        } catch {
            print("CloudKit error - \(CloudKitError.unableToGetAccountStatus)")
        }
    }
    
    func saveVote(for pizza: Pizza) async {
        isSaving = true
        do {
            guard let user = userID?.recordName else {
                print("CloudKit error - \(CloudKitError.unableToGetUserName)")
                throw CloudKitError.unableToSaveRecord
            }
            let vote = PizzaVote(pizzaId: pizza.id, name: pizza.name, user: user)
            try await save(vote.record())
            votedAlready = true
            await checkIfVoted()
            await fetchPizzaResults()
        } catch {
            print("CloudKit error - \(CloudKitError.unableToSaveRecord)")
        }
        isSaving = false
    }
    
    func delete() async {
        isSaving = true
        do {
            guard let record = currentCloudRecord else {
                print("CloudKit error - \(CloudKitError.unableToGetUserName)")
                throw CloudKitError.unableToDeleteRecord
            }
            try await delete(record)
            await checkIfVoted()
            await fetchPizzaResults()
            votedAlready = false
        } catch {
            print("CloudKit error - \(CloudKitError.unableToDeleteRecord)")
        }
        isSaving = false
    }

    func checkIfVoted() async {
        do {
            if let voted = try await fetchVoteRecord() {
                vote = voted
                votedAlready = true
            } else {
                votedAlready = false
            }
        } catch {
            print("CloudKit error - \(CloudKitError.unableToFetchRecord)")
        }
    }
    
    func subscribeForPushNotifications() async {
        do {
            let _ = try await subscribe()
        } catch {
            print("CloudKit error - \(CloudKitError.unableToSubscribe)")
        }
    }
    
    func fetchPizzaResults() async {
        do {
            let results = try await fetchAll()
            UserDefaultsHelper.save(results: results.getPizzaResults())
            pizzaResults = results.getPizzaResults()
        } catch {
            print("CloudKit error - \(CloudKitError.unableToFetchAll)")
        }
    }
    
    func processPushNotification() async {
        do {
            await fetchPizzaResults()
            guard let results = pizzaResults else { return }
            LiveActivityManager.shared.updateLiveActivity(for: results, from: .cloud)
        }
    }
}

// MARK: - Private Methods
extension CloudKitService {
    private func checkAccountStatus() async throws -> CKAccountStatus {
        try await container.accountStatus()
    }
    
    private func getUserID() async throws -> CKRecord.ID {
        try await container.userRecordID()
    }
    
    private func save(_ record: CKRecord) async throws {
        try await container.publicCloudDatabase.save(record)
    }
    
    private func delete(_ record: CKRecord) async throws {
        try await container.publicCloudDatabase.deleteRecord(withID: record.recordID)
    }
    
    private func fetchVoteRecord() async throws -> PizzaVote? {
        guard let user = userID?.recordName else {
            print("CloudKit error - \(CloudKitError.unableToGetUserName)")
            throw CloudKitError.unableToFetchRecord
        }
        let predicate = NSPredicate(
            format: "\(PizzaVoteRecordKeys.user.rawValue) = %@",
            user
        )

        let query = CKQuery(
            recordType: PizzaVoteRecordKeys.type.rawValue,
            predicate: predicate
        )

        query.sortDescriptors = [.init(key: PizzaVoteRecordKeys.pizzaId.rawValue, ascending: true)]

        let result = try await container.publicCloudDatabase.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        currentCloudRecord = records.first
        return records.compactMap(PizzaVote.init).first
    }
    
    private func fetchAll() async throws -> [PizzaVote] {
        let predicate = NSPredicate(value: true)

        let query = CKQuery(
            recordType: PizzaVoteRecordKeys.type.rawValue,
            predicate: predicate
        )

        query.sortDescriptors = [.init(key: PizzaVoteRecordKeys.pizzaId.rawValue, ascending: true)]

        let result = try await container.publicCloudDatabase.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(PizzaVote.init)
    }
    
    private func subscribe() async throws -> CKSubscription {
        let newSubscription = CKQuerySubscription(recordType: PizzaVoteRecordKeys.type.rawValue,
                                                  predicate: NSPredicate(value: true),
                                                  subscriptionID: Constants.subscriptionID,
                                                  options: [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate])

        let notification = CKSubscription.NotificationInfo()
        notification.shouldSendContentAvailable = true
        
        newSubscription.notificationInfo = notification

        return try await container.publicCloudDatabase.save(newSubscription)
    }
}
