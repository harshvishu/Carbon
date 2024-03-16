//
//  Emissions.swift
//  Carbon
//
//  Created by Harsh on 16/03/24.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let emissions = try? JSONDecoder().decode(Emissions.self, from: jsonData)

// MARK: - Emissions
struct Emissions: Codable, Equatable {
    let co2E: Double?
    let co2EUnit, co2ECalculationMethod, co2ECalculationOrigin: String?
    let emissionFactor: EmissionFactor?
    let constituentGases: ConstituentGases?
    let activityData: ActivityData?
    let auditTrail: String?

    enum CodingKeys: String, CodingKey {
        case co2E = "co2e"
        case co2EUnit = "co2e_unit"
        case co2ECalculationMethod = "co2e_calculation_method"
        case co2ECalculationOrigin = "co2e_calculation_origin"
        case emissionFactor = "emission_factor"
        case constituentGases = "constituent_gases"
        case activityData = "activity_data"
        case auditTrail = "audit_trail"
    }
}

// MARK: - ActivityData
struct ActivityData: Codable, Equatable {
    let activityValue: Double?
    let activityUnit: String?

    enum CodingKeys: String, CodingKey {
        case activityValue = "activity_value"
        case activityUnit = "activity_unit"
    }
}

// MARK: - ConstituentGases
struct ConstituentGases: Codable, Equatable {
    let co2ETotal: Double?

    enum CodingKeys: String, CodingKey {
        case co2ETotal = "co2e_total"
    }
}

// MARK: - EmissionFactor
struct EmissionFactor: Codable, Equatable {
    let name, activityID, id, accessType: String?
    let source, sourceDataset: String?
    let year: Int?
    let region, category, sourceLcaActivity: String?

    enum CodingKeys: String, CodingKey {
        case name
        case activityID = "activity_id"
        case id
        case accessType = "access_type"
        case source
        case sourceDataset = "source_dataset"
        case year, region, category
        case sourceLcaActivity = "source_lca_activity"
    }
    
}

extension Emissions {
    static let mock = Emissions(
        co2E: 250,
        co2EUnit: "kg",
        co2ECalculationMethod: "ar4",
        co2ECalculationOrigin: "source",
        emissionFactor: EmissionFactor(
            name: "Electricity supplied from grid",
            activityID: "electricity-supply_grid-source_supplier_mix",
            id: "electricity-supply_grid-source_supplier_mix",
            accessType: "public",
            source: "IEA",
            sourceDataset: "IEA Life Cycle Upstream Emission Factors 2023 (Pilot Edition)",
            year: 2022,
            region: "IN",
            category: "Electricity",
            sourceLcaActivity: "well_to_tank"
        ),
        constituentGases: ConstituentGases(
            co2ETotal: 112.5
        ),
        activityData: ActivityData(
            activityValue: 1000,
            activityUnit: "kWh"
        ),
        auditTrail: "selector"
    )
}
