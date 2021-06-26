//
//  AirQualityStandardTableViewCell.swift
//  ProximityAirQualityMonitor
//
//  Created by Abhinav Mathur on 27/06/21.
//

import UIKit

class AirQualityStandardTableViewCell: UITableViewCell {

    @IBOutlet weak var aqiRange: UILabel!
    @IBOutlet weak var categoryIndex: UILabel!
    
    func configure(_ category: AirQualityIndex) {
        switch category {
        case .good:
            aqiRange.text = "\(AirQualityRange.goodRange.lowerBound) - \(AirQualityRange.goodRange.upperBound)"
        case .satisfactory:
            aqiRange.text = "\(AirQualityRange.satisfactoryRange.lowerBound) - \(AirQualityRange.satisfactoryRange.upperBound)"
        case .moderate:
            aqiRange.text = "\(AirQualityRange.moderateRange.lowerBound) - \(AirQualityRange.moderateRange.upperBound)"
        case .poor:
            aqiRange.text = "\(AirQualityRange.poorRange.lowerBound) - \(AirQualityRange.poorRange.upperBound)"
        case .veryPoor:
            aqiRange.text = "\(AirQualityRange.veryPoorRange.lowerBound) - \(AirQualityRange.veryPoorRange.upperBound)"
        case .severe:
            aqiRange.text = "\(AirQualityRange.severeRange.lowerBound) - \(AirQualityRange.severeRange.upperBound)"
        case .notAvailable:
            aqiRange.text = ""
        }
        
        categoryIndex.text = category.rawValue
        backgroundColor = category.colour
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.0
    }
}
