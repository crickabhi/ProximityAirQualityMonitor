//
//  AirQualityVisualizationVC.swift
//  ProximityAirQualityMonitor
//
//  Created by Abhinav Mathur on 25/06/21.
//

import UIKit
import Charts

protocol AQIObserverDelegate: AnyObject {
    func updateCityAQI(_ airQuality: [CityAirQuality])
}

class AirQualityVisualizationVC: UIViewController {
    // MARK: - Constants
    static private let VC_IDENTIFIER = "AirQualityVisualizationVC"
    private let AXIS_LINE_COLOR = UIColor(red: 34/255, green: 35/255, blue: 38/255, alpha: 1.0)
    private let AXIS_TEXT_COLOR = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.9)
    private let VC_TITLE = "City AQI"
    
    // MARK: - Variables
    @IBOutlet weak var chartView: LineChartView!
    private var currentData = [ChartDataEntry]()
    private let formatter = NumberFormatter()
    private var selectedChartDataEntry : ChartDataEntry?
    private var chartData = [CityAirQuality]()
    
    unowned var viewModel: AirQualityVM!
    
    // MARK: - Initialisation Methods
    class func getInstance(with data: [CityAirQuality], viewModel: AirQualityVM) -> AirQualityVisualizationVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: VC_IDENTIFIER) as! AirQualityVisualizationVC
        vc.chartData = data
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(chartData.first?.city ?? "") \(VC_TITLE)"
        registerObserver()
        basicInitialisation()
    }
    
    private func basicInitialisation() {
        // Set ChartView Delegate
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = true
        
        // Set Chart x-Axis and left-Axis
        let xAxis = chartView.xAxis
        xAxis.gridColor = .clear
        xAxis.labelPosition = .bottom
        
        let leftAxis = chartView.leftAxis
        leftAxis.gridColor = .clear
        
        xAxis.labelTextColor = AXIS_TEXT_COLOR
        leftAxis.labelTextColor = AXIS_TEXT_COLOR
        xAxis.axisLineColor = AXIS_LINE_COLOR
        leftAxis.axisLineColor = AXIS_LINE_COLOR
        
        // Set x-Asis formatter
        xAxis.granularity = 7
        xAxis.axisMaxLabels = 4
        xAxis.valueFormatter = DateValueFormatter()
        
        // Set Marker
        let marker = BalloonMarker(color: .red, font: UIFont.systemFont(ofSize: 14), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        // Hide right-Axis
        chartView.rightAxis.enabled = false
        chartView.legend.form = .line
        setupGraph(chartData)
    }
    
    private func setupGraph(_ values: [CityAirQuality]) {
        var chartEntries = [ChartDataEntry]()
        
        for value in values {
            chartEntries.append(ChartDataEntry(x: value.time.timeIntervalSince1970, y: value.aqi))
        }
        let data = LineChartData(dataSet: getGraphDataSet(values:chartEntries, metricName: "AQI"))
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        chartView.data = data
        
        view.layoutIfNeeded()
    }
    
    private func getGraphDataSet(values: [ChartDataEntry]?, metricName: String) -> LineChartDataSet {
        let set = LineChartDataSet(entries: values, label: metricName)
        
        // Configure Line Chart Data Set
        set.highlightEnabled = true
        set.lineWidth = 1
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightLineDashLengths = [5, 10]
        
        // If Sinle data point then show filled circle
        if let points = values,
            points.count > 1 {
            set.circleRadius = 0
            set.drawCircleHoleEnabled = false
            set.circleHoleRadius = 0
        }
        else {
            set.circleRadius = 3
            set.drawCircleHoleEnabled = true
            set.circleHoleRadius = 0
        }
        return set
    }
}

// MARK: - Observers
extension AirQualityVisualizationVC {
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
            break
        case .updateCityAQI(let updatedData):
            guard let newData = updatedData else {
                return
            }
            setupGraph(newData)
        }
    }
}

// MARK: - ChartViewDelegate
extension AirQualityVisualizationVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectedChartDataEntry?.icon = nil
        selectedChartDataEntry = entry
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
    }
}
