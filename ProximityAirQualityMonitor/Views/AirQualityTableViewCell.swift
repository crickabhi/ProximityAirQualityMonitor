//
//  AirQualityTableViewCell.swift
//  ProximityAirQualityMonitor
//
//  Created by Abhinav Mathur on 25/06/21.
//

import UIKit

class AirQualityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    func configure(_ cityAirQuality: CityAirQuality) {
        cityLabel.text = cityAirQuality.city
        aqiLabel.text = "\(cityAirQuality.aqi)"
        
        lastUpdatedLabel.text = cityAirQuality.lastUpdated
        if cityAirQuality.hasDegraded {
            backgroundColor = cityAirQuality.category.colour
            aqiLabel.textColor = cityAirQuality.category.backgroundColour
        } else {
            backgroundColor = cityAirQuality.category.backgroundColour
            aqiLabel.textColor = cityAirQuality.category.colour
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.0
    }
}
