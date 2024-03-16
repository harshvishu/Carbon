//
//  Transaction.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import Foundation
import ComposableArchitecture
import SwiftData

@Model
final class Transaction: Identifiable {
    @Attribute(.unique) let id = UUID()
    
    var amount: Double
    var _description: String
    var type: TransactionType
    var category: TransactionCategory
    var date: Date = Date()
    var fromAccount: String
    var emissions: Emissions?
    
    init(amount: Double, _description: String, type: TransactionType, category: TransactionCategory, fromAccount: String = "") {
        self.amount = amount
        self._description = _description
        self.type = type
        self.category = category
        self.fromAccount = fromAccount
    }
}

enum TransactionType: String, Codable {
    case debit = "debit"
    case credit = "credit"
    
    var icon: String {
        switch self {
        case .debit: "arrow.down"
        case .credit: "up.down"
        }
    }
}

enum TransactionCategory: Equatable, Codable, Identifiable {
    var id: String {
        activity_id
    }
    
    case electricity
    
    case fuel(Fuel)
    enum Fuel: Equatable, Codable {
        case petrol
        case diesel
    }
    
    case water
    case travel(Travel)
    enum Travel: Equatable, Codable {
        case internationalFlight
        case domesticFlight
        case dieselTrain
        case electricTrain
        case dieselBus
        case electricBus
        case fuelCab
        case electricCab
    }
    
    var activity_id: String {
        switch self {
        case .electricity: "electricity-supply_grid-source_supplier_mix"
        case let .fuel(type):
            switch type {
            case .petrol: "passenger_vehicle-vehicle_type_car-fuel_source_bio_petrol-distance_na-engine_size_medium"
            case .diesel:"passenger_vehicle-vehicle_type_car-fuel_source_diesel-distance_long-engine_size_na"
            }
        case .water: "water_supply-type_na"
        case let .travel(type):
            switch type {
                
            case .internationalFlight:
                "passenger_flight-route_type_international-aircraft_type_na-distance_long_haul_gt_3700km-class_business-rf_included"
            case .domesticFlight:
                "passenger_flight-route_type_domestic-aircraft_type_jet-distance_na-class_na-rf_included"
            case .electricTrain:
                "passenger_train-route_type_local-fuel_source_electricity"
            case .dieselTrain:
                "passenger_train-route_type_local-fuel_source_diesel"
            case .dieselBus:
                "passenger_vehicle-vehicle_type_bus-fuel_source_diesel-distance_na-engine_size_na"
            case .electricBus:
                "passenger_vehicle-vehicle_type_city_bus-fuel_source_bev-distance_na-engine_size_na"
            case .fuelCab:
                "passenger_vehicle-vehicle_type_black_cab-fuel_source_na-engine_size_na-vehicle_age_na-vehicle_weight_na"
            case .electricCab:
                "passenger_vehicle-vehicle_type_business_travel_car-fuel_source_bev-engine_size_na-vehicle_age_na-vehicle_weight_na"
            }
        }
    }
    
    var name: String {
        switch self {
        case .electricity: "Electricity Bill"
        case .fuel: "Gas Station"
        case .travel: "Travel"
        case .water: "Water Bill"
        }
    }
    
    var icon: String {
        switch self {
        case .electricity: "bolt.fill"
        case .fuel: "fuelpump.fill"
        case .water: "waterbottle.fill"
        case let .travel(type):
            switch type {
            case .internationalFlight, .domesticFlight:
                "airplane"
            case .dieselTrain, .electricTrain:
                "tram"
            case .electricBus, .dieselBus:
                "bus"
            case .fuelCab:
                "car.side"
            case .electricCab:
                "bolt.car"
            }
        }
    }
}

extension Transaction {
    static let mock: [Transaction] = [
        Transaction(
            amount: 1200,
            _description: "Electricity Bill",
            type: .debit,
            category: .electricity
        ),
        Transaction(
            amount: 5000,
            _description: "petrol",
            type: .debit,
            category: .fuel(.petrol)
        ),
        Transaction(
            amount: 200,
            _description: "Water Bill",
            type: .debit,
            category: .water
        )
    ]
}
