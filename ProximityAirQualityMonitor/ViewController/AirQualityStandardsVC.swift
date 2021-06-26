//
//  AirQualityStandardsVC.swift
//  ProximityAirQualityMonitor
//
//  Created by Abhinav Mathur on 27/06/21.
//

import UIKit

class AirQualityStandardsVC: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

}

// MARK:- UITableViewDelegate
extension AirQualityStandardsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK:- UITableViewDataSource
extension AirQualityStandardsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AirQualityIndex.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AirQualityStandardTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.configure(AirQualityIndex.allCases[indexPath.row])
        return cell
    }
}
