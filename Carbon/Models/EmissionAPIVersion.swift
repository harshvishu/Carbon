//
//  EmissionAPIVersion.swift
//  Carbon
//
//  Created by Harsh on 16/03/24.
//

import Foundation

struct EmissionAPIVersion: Codable {
    let latest: String?
    let latestMajor, latestMinor: Int?

    enum CodingKeys: String, CodingKey {
        case latest
        case latestMajor = "latest_major"
        case latestMinor = "latest_minor"
    }
}
