//
//  Database.swift
//  Carbon
//
//  Created by Harsh on 16/03/24.
//

import Foundation
import SwiftData
import ComposableArchitecture

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Transaction.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

// MARK: Golbal Swift Data Dependency
extension DependencyValues {
    var databaseService: Database {
        get {self[Database.self]}
        set{self[Database.self] = newValue}
    }
}

struct Database {
    var context: () throws -> ModelContext
}

extension Database: DependencyKey {
    public static let liveValue = Self(
        context: { ModelContext(sharedModelContainer) }
    )
}

// MARK: Wokrout Database
extension DependencyValues {
    var transactionDatabase: TransactionDatabase {
        get{self[TransactionDatabase.self]}
        set{self[TransactionDatabase.self] = newValue}
    }
}

struct TransactionDatabase {
    var fetchAll: @Sendable () throws -> [Transaction]
    var fetch: @Sendable (FetchDescriptor<Transaction>) throws -> [Transaction]
    var add: @Sendable (Transaction) throws -> Void
    var delete: @Sendable (Transaction) throws -> Void
    
    enum TransactionError: Error {
        case add
        case delete
    }
}

extension TransactionDatabase: DependencyKey {
    public static let liveValue = Self(
        fetchAll: {
            do {
                @Dependency(\.databaseService) var databaseService
                let databaseContext = try databaseService.context()
                
                let descriptor = FetchDescriptor<Transaction>(sortBy: [SortDescriptor(\Transaction.date, order: .reverse)])
                return try databaseContext.fetch(descriptor)
            } catch {
                print(error)
                return []
            }
        }, fetch: { descriptor in
            do {
                @Dependency(\.databaseService) var databaseService
                let databaseContext = try databaseService.context()

                return try databaseContext.fetch(descriptor)
            } catch {
                print(error)
                return []
            }
        }, add: { model in
            do {
                @Dependency(\.databaseService) var databaseService
                let databaseContext = try databaseService.context()
                
                databaseContext.insert(model)
                
            } catch {
                throw TransactionError.add
            }
        }, delete: { model in
            do {
                @Dependency(\.databaseService) var databaseService
                let databaseContext = try databaseService.context()
                
                databaseContext.delete(model)
            } catch {
                throw TransactionError.delete
            }
        }
    )
}

extension TransactionDatabase {
    static func mock() -> Self {
        Self(fetchAll: {
            Transaction.mock
        }, fetch: { _ in
            Transaction.mock
        },
             add: { _ in
            
        }, delete: { _ in
            
        })
    }
}
