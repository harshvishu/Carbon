//
//  EmissionsQuery.swift
//  Carbon
//
//  Created by Harsh on 16/03/24.
//

import Foundation

struct EmissionsQuery: Codable, Sendable, Equatable {
    var emission_factor: EmissionFactor
    var parameters: Parameters
    
    struct EmissionFactor: Codable, Sendable, Equatable {
        var activity_id: String
        var data_version: String = "^10"
//        var region_fallback = true
//        var region = "IN"   // India for now
    }
    
    struct Parameters: Codable, Sendable, Equatable {
        var energy: Double?
        var energy_unit: EnergyUnit?
        
        var money: Double?
        var money_unit: MoneyUnit?
        
        var distance: Double?
        var distance_unit: DistanceUnit?
        
        var time: Double?
        var time_unit: TimeUnit?
        
        var volume: Double?
        var volume_unit: VolumeUnit?
        
        var weight: Double?
        var weight_unit: WeightUnit?
        
        var passengers: Int?
        
        init() {
            
        }
        
        init(energy: Double, energy_unit: EnergyUnit) {
            self.energy = energy
            self.energy_unit = energy_unit
        }
        
        /// Money (Cash)
        init(money: Double, money_unit: MoneyUnit = .inr) {
            self.money = money
            self.money_unit = money_unit
        }
        
        /// Distance over time
        init(distance: Double, distance_unit: DistanceUnit, time: Double, time_unit: TimeUnit) {
            self.distance = distance
            self.distance_unit = distance_unit
            self.time = time
            self.time_unit = time_unit
        }
        
        /// Distance
        init(distance: Double, distance_unit: DistanceUnit) {
            self.distance = distance
            self.distance_unit = distance_unit
        }
        
        /// Volume
        init(volume: Double, volume_unit: VolumeUnit) {
            self.volume = volume
            self.volume_unit = volume_unit
        }
        
        /// Weight over distance
        init(weight: Double, weight_unit: WeightUnit, distance: Double, distance_unit: DistanceUnit) {
            self.weight = weight
            self.weight_unit = weight_unit
            self.distance = distance
            self.distance_unit = distance_unit
        }
        
        init(passengers: Int, distance: Double, distance_unit: DistanceUnit) {
            self.passengers = passengers
            self.distance = distance
            self.distance_unit = distance_unit
        }
    }
    
    enum EnergyUnit: String, Codable, Sendable, Equatable {
        case Wh, kWh, MWh
    }
    
    enum MoneyUnit: String, Codable, Sendable, Equatable {
        case inr, eur, usd
    }
    
    enum TimeUnit: String, Codable, Sendable, Equatable {
       case ms, s, m, h, day, year
    }
    
    enum DistanceUnit: String, Codable, Sendable, Equatable {
       case m, km, ft, mi
    }
    
    enum VolumeUnit: String, Codable, Sendable, Equatable {
        case ml, l, gallons_us
    }
    
    enum WeightUnit: String, Codable, Sendable, Equatable {
        case g, kg, t, lb, ton
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
