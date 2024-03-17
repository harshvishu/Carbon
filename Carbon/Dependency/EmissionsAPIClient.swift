//
//  EmissionsAPIClient.swift
//  Carbon
//
//  Created by Harsh on 16/03/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct EmissionsAPIClient {
    var estimate: @Sendable (_ query: EmissionsQuery) async throws -> Emissions
    var version: @Sendable () async throws -> EmissionAPIVersion
}

extension DependencyValues {
    var climateAPIClient: EmissionsAPIClient {
        get { self[EmissionsAPIClient.self] }
        set { self[EmissionsAPIClient.self] = newValue }
    }
}

extension EmissionsAPIClient: DependencyKey {
    static let liveValue = EmissionsAPIClient(estimate: { query in
        var request = URLRequest(url: URL(string: "https://api.climatiq.io/estimate")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // TODO: make this dynamic : Use multiple accounts
        request.setValue("Bearer TJARTTTEP44VJVKN9MXP772FJQ9A", forHTTPHeaderField: "Authorization")
        try request.httpBody = query.jsonData()
        
        print("Sending estimate API request...")
        print(try? query.jsonString())
        dump(request)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        dump(String(data: data, encoding: .utf8))
        
        return try JSONDecoder().decode(Emissions.self, from: data)
    }, version: {
        var request = URLRequest(url: URL(string: "https://api.climatiq.io/data/v1/data-versions")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // TODO: make this dynamic : Use multiple accounts
        request.setValue("Bearer TJARTTTEP44VJVKN9MXP772FJQ9A", forHTTPHeaderField: "Authorization")

        print("Sending estimate API request...")
        dump(request)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        dump(String(data: data, encoding: .utf8))
        
        return try JSONDecoder().decode(EmissionAPIVersion.self, from: data)
    })
}
