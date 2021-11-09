//
//  AsteroidController.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import UIKit
import Charts

enum enCellType: String {
    case normal, speedSorted, distanceSorted, avgSizeSorted, none
}

class AsteroidController: NSObject {
    
    var success: SuccessResponse? // Called When Got Success Data From Server
    var failure: FailureResponse? // Called When Got ErrorData From Server
    
    var asteroidRequestData = SMAsteroidRequest()
    var baseDataAsteroid = SMBaseDataAsteroid()
    var sortedAsteroidList = [SMAsteroid]()
    var cellType: enCellType = .normal
    
    static let gridColor = UIColor.black
    static let barColor = UIColor.blue
    
}

extension AsteroidController {
    
    func sortAsteroidList() {
        sortedAsteroidList.removeAll()
        var aList = [SMAsteroid]()
        baseDataAsteroid.nearEarthObjects.forEach { data in
            aList.append(contentsOf: data.asteroidList)
        }
        switch cellType {
        case .normal: break
        case .speedSorted:
            sortedAsteroidList = aList.sorted(by: { $0.closeApproachData.kilometersPerHour > $1.closeApproachData.kilometersPerHour})
        case .distanceSorted:
            sortedAsteroidList = aList.sorted(by: { $0.closeApproachData.kilometers < $1.closeApproachData.kilometers})
        case .avgSizeSorted:
            sortedAsteroidList = aList.sorted(by: { $0.avgSize > $1.avgSize})
        default: break
        }
        successCompletionHandler(json: JSON())
    }
}

extension AsteroidController {
    
    private func successCompletionHandler(json: JSON) {
        guard let completion = self.success else { return }
        completion(json)
    }
    
    private func failureCompletionHandler(error: NSError) {
        guard let completion = self.failure else { return }
        completion(error)
    }
}

extension AsteroidController {
    
    func doValidate() {
        var errorString = ""
        switch asteroidRequestData.startDate.count > 0 {
        case true: break
        case false:
            switch errorString.count > 0 {
            case true: errorString = errorString + "Please select your start date\n"
            case false: errorString = "Please select your start date\n"
            }
        }
        
        switch asteroidRequestData.endDate.count > 0 {
        case true: break
        case false:
            switch errorString.count > 0 {
            case true: errorString = errorString + "Please select your end date\n"
            case false: errorString = "Please select your end date\n"
            }
        }
        if errorString.count > 0 {
            AlertController.showToastWithMessage(errorString)
        }
        else {
            callWebServiceForFetchingAsteroidData()
        }
    }
    
    func callWebServiceForFetchingAsteroidData() {
        gAPICallManager.insertApiCallUsing(startDate: asteroidRequestData.startDate, andEndDate: asteroidRequestData.endDate) {json in
            
            switch json["code"].intValue {
            case 400:
                AlertController.showToastWithMessage(json["error_message"].stringValue)
            default:
                self.baseDataAsteroid = SMBaseDataAsteroid(json: json)
                self.successCompletionHandler(json: json)
            }
        }
    }
}

extension AsteroidController {
    
    static func setupChart(_ chartView: BarChartView){
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.xAxis.labelTextColor = gridColor
        chartView.rightAxis.labelTextColor = gridColor
        chartView.xAxis.gridColor = gridColor
        chartView.rightAxis.gridColor = gridColor
        let legend = chartView.legend
        legend.textColor = gridColor
        legend.form = .none
    }
    
    func setChartForDays(dayBarChartView: BarChartView) {
        dayBarChartView.noDataText = "You need to provide data for the chart."
        var dataEntries:[BarChartDataEntry] = []

        for i in 0..<baseDataAsteroid.nearEarthObjects.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(baseDataAsteroid.nearEarthObjects[i].asteroidList.count))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors  = [AsteroidController.barColor]
        chartDataSet.drawValuesEnabled = false
        let chartData = BarChartData(dataSet: chartDataSet)

        dayBarChartView.data = chartData
        
        let xAxisValue = dayBarChartView.xAxis
        xAxisValue.valueFormatter = self
        xAxisValue.wordWrapEnabled = true
        dayBarChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        dayBarChartView.notifyDataSetChanged()
    }
}

extension AsteroidController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return baseDataAsteroid.nearEarthObjects[Int(value)].formattedDate
    }
}
