//
//  AirQualityVM.swift
//  ProximityAirQualityMonitor
//
//  Created by Abhinav Mathur on 24/06/21.
//

import Foundation
import Starscream

public typealias AQIClosure<Type> = (Type)->Void

enum AQIObserverEvent {
    case updateDisplayList
    case updateCityAQI([CityAirQuality]?)
}

class AirQualityVM {
    
    private var socket: WebSocket!
    private let server = WebSocketServer()
    
    var isConnected = false
    var observer: AQIClosure<AQIObserverEvent>?
    var displayList = [CityAirQuality]()
    var detailedCityAQI = [String: [CityAirQuality]]()
    
    var selectedCity: CityAirQuality?
    
    init() {
        createConnection()
    }
    
    func createConnection() {
        var request = URLRequest(url: URL(string: "ws://city-ws.herokuapp.com/")!)
        request.timeoutInterval = 10
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func parse(data: Data?) {
        guard let jsondata = data else {
            return
        }
        let decoder = JSONDecoder()
        if let cityAirQuality = try? decoder.decode([CityAirQuality].self, from: jsondata) {
            updateList(cityAirQuality)
            observer?(.updateDisplayList)
            guard let city = selectedCity else {
                return
            }
            observer?(.updateCityAQI(detailedCityAQI[city.city]))
        }
    }
    
    func updateList(_ list: [CityAirQuality]) {
        for item in list {
            var newItem = item
            // Latest AQI for city
            if let oldItem = displayList.filter({$0 == item}).first,
               let index = displayList.firstIndex(of: oldItem)
               {
                newItem.lastUpdated = oldItem.time.timeAgo
                if newItem.category == .poor && oldItem.category == .good {
                    newItem.hasDegraded = true
                }
                displayList.remove(at: index)
                displayList.insert(newItem, at: index)
            } else {
                displayList.append(newItem)
            }
            
            // Curated AQI for city
            if var values = detailedCityAQI[newItem.city] {
                values.append(newItem)
                detailedCityAQI[newItem.city] = values.sorted(by: {$0.time < $1.time})
            } else {
                detailedCityAQI[newItem.city] = [newItem]
            }
        }
    }
}


extension AirQualityVM: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received data: \(string)")
            parse(data: string.data(using: .utf8))
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
