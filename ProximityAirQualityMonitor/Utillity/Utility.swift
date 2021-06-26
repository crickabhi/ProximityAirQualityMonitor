//
//  Utility.swift
//  ProximityAirQualityMonitor
//
//  Created by Abhinav Mathur on 25/06/21.
//

import Foundation
import Charts

class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: value))
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: date!)
    }
}

extension Date {
    var timeAgo: String {
        let interval = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        
        if let day = interval.day, day > 0 {
            return day == 1 ? "\(day) day" : "\(day) days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour) hour" : "\(hour) hours"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "A minute ago" : "\(minute) minutes"
        }
        else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second) second" : "\(second) seconds"
        }
        else {
            return "A few seconds ago"
        }
        
    }
}

extension Double {
    func roundToPlaces(_ places: Int) -> Double {
        let divisor = pow(10, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UITableView {
    func dequeue<T: UITableViewCell>(cellForRowAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
