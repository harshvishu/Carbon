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
        case .credit: "arrow.down"
        case .debit: "arrow.up"
        }
    }
}

enum TransactionCategory: String, Equatable, Codable, Identifiable, CaseIterable {
    var id: String {
        self.rawValue
    }
    
    case clothing
    case cashWithdrawl
    case credit
    case electricity
    case food
    case petrol
    case diesel
    case water
    case internationalFlight
    case domesticFlight
    case dieselTrain
    case electricTrain
    case dieselBus
    case electricBus
    case fuelCab
    case electricCab
    case ferry
    
    
    var activity_id: String {
        switch self {
        case .cashWithdrawl:
            "financial_services-type_financial_intermediation_services_except_insurance_pension_funding_services"
        case .credit:
            "financial_services-type_other_depository_credit_intermediation"
        case .clothing: "consumer_goods-type_wearing_apparel_furs"
        case .electricity: "electricity-supply_grid-source_supplier_mix"
        case .food: "consumer_goods-type_food_products_not_elsewhere_specified"
        case .petrol: "passenger_vehicle-vehicle_type_car-fuel_source_bio_petrol-distance_na-engine_size_medium"
        case .diesel:"passenger_vehicle-vehicle_type_car-fuel_source_diesel-distance_long-engine_size_na"
        case .water: "water_supply-type_na"
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
        case .ferry:
            "passenger_ferry-route_type_na-fuel_source_na"
        }
    }
    
    var name: String {
        switch self {
        case .cashWithdrawl:
            "ATM Cash Withdrawl"
        case .electricity: "Electricity Bill"
        case .petrol, .diesel: "Gas Station"
        case .credit:
            "Credit"
        case .internationalFlight:
            "International Flight"
        case .domesticFlight:
            "Domestic Flight"
        case .dieselTrain:
            "Train Travel"
        case .electricTrain:
            "Train Travel"
        case .dieselBus:
            "Bus"
        case .electricBus:
            "Electric Bus"
        case .fuelCab:
            "Cab"
        case .electricCab:
            "Electric Cab"
        case .ferry:
            "Sea Travel/Ferry"
        case .water: "Water Bill"
        case .clothing:
            "Clothing and Footwear"
        case .food:
            "Food/Beverages/Tobacco"
        }
    }
    
    var icon: String {
        switch self {
        case .cashWithdrawl:
            "indianrupeesign"
        case .credit:
            "indianrupeesign"
        case .clothing: "shoe.2"
        case .food: "fork.knife"
        case .electricity: "bolt.fill"
        case .petrol, .diesel: "fuelpump.fill"
        case .water: "waterbottle.fill"
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
        case .ferry:
            "ferry"
        }
    }
    
    var isGreen: Bool {
        switch self {
        case .electricity, .petrol, .diesel, .water, .clothing, .food, .cashWithdrawl, .credit, .internationalFlight, .domesticFlight, .dieselTrain, .dieselBus, .fuelCab:
            false
        case .electricTrain, .electricBus, .electricCab, .ferry:
            true
        }
    }
    
    func query(money: Double) -> EmissionsQuery {
        let parameters: EmissionsQuery.Parameters =
        switch self {
        case .cashWithdrawl, .credit:
            cash(money: money)
        case .clothing:
            clothing(money: money)
        case .electricity:
            electricity(money: money)
        case .food:
            food(money: money)
        case .petrol, .diesel:
            fuel(money: money)
        case .water:
            water(money: money)
        case .dieselBus:
            dieselBus(money: money)
        case .dieselTrain:
            dieselTrain(money: money)
        case .domesticFlight:
            domesticFlight(money: money)
        case .electricBus:
            electricBus(money: money)
        case .electricCab:
            electricCab(money: money)
        case .electricTrain:
            electricTrain(money: money)
        case .fuelCab:
            fuelCab(money: money)
        case .internationalFlight:
            internationalFlight(money: money)
        case .ferry:
            ferry(money: money)
        }
        return EmissionsQuery(emission_factor: .init(activity_id: activity_id), parameters: parameters)
    }
}

extension TransactionCategory {
    func clothing(money: Double) -> EmissionsQuery.Parameters {
        .init(money: money, money_unit: .inr)
    }
    
    func food(money: Double) -> EmissionsQuery.Parameters {
        .init(money: money, money_unit: .inr)
    }
    
    func electricity(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(energy: (money / 7.5), energy_unit: .kWh)
    }
    
    func fuel(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 10), distance_unit: .km)
    }
    
    func water(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(volume: (money / 0.055), volume_unit: .l)
    }
    
    func domesticFlight(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 4), distance_unit: .km)
    }
    
    func internationalFlight(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 10), distance_unit: .km)
    }
    
    func electricTrain(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 2), distance_unit: .km)
    }
    
    func dieselTrain(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 3), distance_unit: .km)
    }
    
    func electricBus(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 5), distance_unit: .km)
    }
    
    func dieselBus(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 6), distance_unit: .km)
    }
    
    func fuelCab(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 8), distance_unit: .km)
    }
    
    func electricCab(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 4), distance_unit: .km)
    }
    
    func ferry(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(passengers: 1, distance: (money / 10), distance_unit: .km)
    }
    
    func cash(money: Double) -> EmissionsQuery.Parameters {
        // Internal arbitirary Conversion
        .init(money: money, money_unit: .inr)
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
            category: .petrol
        ),
        Transaction(
            amount: 200,
            _description: "Water Bill",
            type: .debit,
            category: .water
        )
    ]
}
