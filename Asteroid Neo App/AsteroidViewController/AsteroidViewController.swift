//
//  AsteroidViewController.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import UIKit
import Charts

class AsteroidViewController: UIViewController {

    @IBOutlet weak var customNavBar: UIView!
    @IBOutlet weak var asteroidTable: UITableView!
    @IBOutlet weak var heightConsCustomNavBar: NSLayoutConstraint!
    
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var bgChartView: UIView!
    @IBOutlet weak var chartView: BarChartView!

    let controller = AsteroidController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
        setupCompletionHandler()
    }
    
    func initialSetup() {
        switch isIPhoneSe {
        case true:
            heightConsCustomNavBar.constant = 84
        case false:
            heightConsCustomNavBar.constant = 98
        }
        bgChartView.draw3DShadow()
        AsteroidController.setupChart(chartView)
        setPlaceHolderColor(textFld: txtStartDate)
        setPlaceHolderColor(textFld: txtEndDate)
    }
    
    func setPlaceHolderColor(textFld: UITextField) {
        textFld.attributedPlaceholder = NSAttributedString(string: textFld.placeholder ?? "",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func setupCompletionHandler() {
        controller.success = { _ in
            DispatchQueue.mainQueueAsync {
                self.reloadTableView()
                self.setupBarChart()
            }
        }
    }
    
    func setupBarChart() {
        controller.setChartForDays(dayBarChartView: chartView)
    }
}

extension AsteroidViewController {
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        
        guard let startDate = txtStartDate.text?.trim() else { return }
        guard let endDate = txtEndDate.text?.trim() else { return }
        controller.asteroidRequestData.startDate = startDate
        controller.asteroidRequestData.endDate = endDate
        controller.doValidate()
        controller.cellType = .normal
    }
    
    @IBAction func btnSortBySpeedClicked(_ sender: UIButton) {
        controller.cellType = .speedSorted
        controller.sortAsteroidList()
    }
    
    @IBAction func btnSortByDistanceClicked(_ sender: UIButton) {
        controller.cellType = .distanceSorted
        controller.sortAsteroidList()
    }
    
    @IBAction func btnSortByAvgSizeClicked(_ sender: UIButton) {
        controller.cellType = .avgSizeSorted
        controller.sortAsteroidList()
    }
    
    @IBAction func btnResetClicked(_ sender: UIButton) {
        controller.cellType = .normal
        controller.sortAsteroidList()
    }
}



extension AsteroidViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let calender = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.locale =  Locale(identifier: "en")
        formatter.dateFormat = "YYYY-MM-dd"
        var currDate = Date()
        var components = DateComponents()
        components.year = 0
        let maxDate = Date()
        components.year = -100
        let minDate = calender.date(byAdding: components, to: currDate)!
        if textField.text != nil && !textField.text!.isEmpty {
            if let curDate = formatter.date(from: textField.text!){
                currDate = curDate
            }
        }
        switch textField {
        case txtStartDate:
            openDatePickerForStartDate(currDate: currDate, minDate: minDate, maxDate: maxDate)
            break
        case txtEndDate:
            openDatePickerForEndDate(currDate: currDate, minDate: minDate, maxDate: maxDate)
            break
        default:
            break
        }
    }
    
    func openDatePickerForStartDate(currDate: Date?, minDate: Date?, maxDate: Date?) {
        
        DatePicker.openPicker(in: txtStartDate, currentDate: currDate, minimumDate: minDate, maximumDate: maxDate, pickerMode: UIDatePicker.Mode.date) { [self] (selectedDate) in
            let formatter = DateFormatter()
            formatter.locale =  Locale(identifier: "en")
            formatter.dateFormat = "YYYY-MM-dd"
            let result = formatter.string(from: selectedDate)
            txtStartDate.text = result
        }
    }
    
    func openDatePickerForEndDate(currDate: Date?, minDate: Date?, maxDate: Date?) {
        
        DatePicker.openPicker(in: txtEndDate, currentDate: currDate, minimumDate: minDate, maximumDate: maxDate, pickerMode: UIDatePicker.Mode.date) { [self] (selectedDate) in
            let formatter = DateFormatter()
            formatter.locale =  Locale(identifier: "en")
            formatter.dateFormat = "YYYY-MM-dd"
            let result = formatter.string(from: selectedDate)
            txtEndDate.text = result
        }
    }
}

extension AsteroidViewController: TableDelegate {
    
    func reloadTableView() {
        DispatchQueue.mainQueueAsync {
            self.asteroidTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch controller.cellType {
        case .normal: return controller.baseDataAsteroid.nearEarthObjects.count
        case .speedSorted, .distanceSorted ,.avgSizeSorted: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch controller.cellType {
        case .normal:
            let asteroidList = controller.baseDataAsteroid.nearEarthObjects[section].asteroidList
            return asteroidList.count
        case .speedSorted, .distanceSorted ,.avgSizeSorted: return controller.sortedAsteroidList.count
        default: return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch controller.cellType {
        case .normal:
            let date = controller.baseDataAsteroid.nearEarthObjects[section].date
            return date
        case .speedSorted: return "Speed Sorted Highest to lowest"
        case .distanceSorted: return "Distance Sorted Closest to farthest"
        case .avgSizeSorted: return "Avg. Size Sorted Data"
        default: return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = asteroidTable.dequeueReusableCell(withIdentifier: "AsteroidTableCell", for: indexPath) as! AsteroidTableCell
        switch controller.cellType {
        case .normal:
            let asteroid = controller.baseDataAsteroid.nearEarthObjects[indexPath.section].asteroidList[indexPath.row]
            aCell.configureCellUI(data: asteroid)
        case .speedSorted:
            let asteroid = controller.sortedAsteroidList[indexPath.row]
            aCell.configureCellUISpeedSorted(data: asteroid)
        case .distanceSorted:
            let asteroid = controller.sortedAsteroidList[indexPath.row]
            aCell.configureCellUIDistanceSorted(data: asteroid)
        case .avgSizeSorted:
            let asteroid = controller.sortedAsteroidList[indexPath.row]
            aCell.configureCellUIAvgSizeSorted(data: asteroid)
        default: break
        }
        return aCell
    }
}
