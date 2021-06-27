//
//  AirQualityVC.swift
//  ProximityAirQualityMonitor
//
//  Created by Abhinav Mathur on 24/06/21.
//

import UIKit
import Starscream

class AirQualityVC: UIViewController {
    // MARK: - Constants
    private let VC_TITLE = "AQI Monitoring"
    private let EMPTY_STATE = "Fetching City's Air Quality Metrics ..."
    private let COLUMN_TITLE_1 = "City"
    private let COLUMN_TITLE_2 = "Current AQI"
    private let COLUMN_TITLE_3 = "Last updated"
    
    // MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    var viewModel = AirQualityVM()
    
    // MARK: - Initialisation Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = VC_TITLE
        tableView.tableFooterView = UIView()
        registerObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.selectedCity = nil
    }
}

// MARK:- UITableViewDelegate
extension AirQualityVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.displayList[indexPath.row - 1]
        if let data = viewModel.detailedCityAQI[city.city] {
            viewModel.selectedCity = city
            let vc = AirQualityVisualizationVC.getInstance(with: data, viewModel: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- UITableViewDataSource
extension AirQualityVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isConnected {
            tableView.restore()
            return viewModel.displayList.count + 1
        } else {
            tableView.setEmptyMessage(EMPTY_STATE)
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AirQualityTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        if indexPath.row == 0 {
            cell.cityLabel.text = COLUMN_TITLE_1
            cell.aqiLabel.text = COLUMN_TITLE_2
            cell.lastUpdatedLabel.text = COLUMN_TITLE_3
        } else {
            cell.configure(viewModel.displayList[indexPath.row - 1])
        }
        return cell
    }
}


// MARK: - Observers
extension AirQualityVC {
    func registerObserver() {
        viewModel.observer = {[weak self] event in
            DispatchQueue.main.async {
                self?.listen(event)
            }
        }
    }
    
    func listen(_ event: AQIObserverEvent) {
        switch event {
        case .updateDisplayList:
            tableView.reloadData()
        case .updateCityAQI(_):
            break
        }
    }
}
