//
//  CityAirQuality.swift
//  ProximityAirQualityMonitor
//
//  Created by Abhinav Mathur on 24/06/21.
//

import UIKit

enum AirQualityRange {
    static let goodRange           = 0...50.00
    static let satisfactoryRange   = 50.01...100.00
    static let moderateRange       = 100.01...200.00
    static let poorRange           = 200.01...300.00
    static let veryPoorRange       = 300.01...400.00
    static let severeRange         = 400.01...500.00
}

enum AirQualityIndex: String, CaseIterable {
    case good           = "Good"
    case satisfactory   = "Satisfactory"
    case moderate       = "Moderate"
    case poor           = "Poor"
    case veryPoor       = "VeryPoor"
    case severe         = "Severe"
    case notAvailable   = "NotAvailable"
    
    
    var colour: UIColor {
        switch self {
        case .good:
            return UIColor(red: 71/255, green: 155/255, blue: 84/255, alpha: 1.0)
        case .satisfactory:
            return UIColor(red: 148/255, green: 192/255, blue: 65/255, alpha: 1.0)
        case .moderate:
            return UIColor(red: 235/255, green: 229/255, blue: 12/255, alpha: 1.0)
        case .poor:
            return UIColor(red: 219/255, green: 114/255, blue: 9/255, alpha: 1.0)
        case .veryPoor:
            return UIColor(red: 225/255, green: 40/255, blue: 39/255, alpha: 1.0)
        case .severe:
            return UIColor(red: 157/255, green: 27/255, blue: 27/255, alpha: 1.0)
        case .notAvailable:
            return .black
        }
    }
    
    var backgroundColour: UIColor {
        return .white
    }
}

protocol CityAQI: Codable {
    var city: String { get }
    var aqi: Double { get }
}

protocol CityDisplay {
    var background: UIColor { get }
}

struct CityAirQuality: CityAQI  {
    var city: String
    var aqi: Double
    var time: Date
    var lastUpdated: String
    var hasDegraded: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.city = try container.decode(String.self, forKey: .city)
        self.aqi = try container.decode(Double.self, forKey: .aqi).roundToPlaces(2)
        self.time = try container.decodeIfPresent(Date.self, forKey: .time) ?? Date()
        self.lastUpdated = try container.decodeIfPresent(String.self, forKey: .lastUpdated) ?? Date().timeAgo
    }
}

extension CityAirQuality: CityDisplay  {
    var background: UIColor {
        return self.category.backgroundColour
    }
}


extension CityAirQuality: Equatable {
    static func == (lhs: CityAirQuality, rhs: CityAirQuality) -> Bool {
        return lhs.city == rhs.city
    }
}

extension CityAirQuality {
    var category: AirQualityIndex {
        switch aqi {
        case AirQualityRange.goodRange:
            return .good
        case AirQualityRange.satisfactoryRange:
            return .satisfactory
        case AirQualityRange.moderateRange:
            return .moderate
        case AirQualityRange.poorRange:
            return .poor
        case AirQualityRange.veryPoorRange:
            return .veryPoor
        case AirQualityRange.severeRange:
            return .severe
        default:
            return .notAvailable
        }
    }
}


/*
 websocket is connected: ["Via": "1.1 vegur", "Sec-WebSocket-Accept": "Mtq5z7VKLvC6imjfDG+7NWyZSyY=", "Upgrade": "websocket", "Connection": "Upgrade"]
 
 Received text: [{"city":"Bengaluru","aqi":191.64147806528513},{"city":"Bhubaneswar","aqi":102.55896666491108},{"city":"Chennai","aqi":143.12800563239477},{"city":"Hyderabad","aqi":200.72363120823348},{"city":"Indore","aqi":49.440963918866984},{"city":"Chandigarh","aqi":47.977841339565984}]
 */
