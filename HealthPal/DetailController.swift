//
//  DetailController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/28.
//

import UIKit
import Charts
import CoreData

class DetailController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var unitSegControl: UISegmentedControl!
    @IBOutlet weak var dataTable: UITableView!
    
    var chartView = LineChartView()
    var weightData = [WeightData]()
    var handData = [HandWashData]()
    var graphValues = [Int64]()
    var maxLimit: Int64 = Int64.max
    var minLimit: Int64 = 0
    var average: Int64 = 0
    var type: String = "weight"
    
    // context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.delegate = self
        unitSegControl.isHidden = type == "hand"
        fetchData()
        updateGraph()
        dataTable.delegate = self
        dataTable.dataSource = self
    }
    
    func fetchData() {
        do {
            self.weightData = try context.fetch(WeightData.fetchRequest())
            self.handData = try context.fetch(HandWashData.fetchRequest())
            self.weightData = self.weightData.sorted(by: { $0.date! > $1.date! })
            self.handData = self.handData.sorted(by: { $0.date! > $1.date! })
        }
        catch {
            print("Failed to fetch core data")
        }
        graphValues.removeAll()
        minLimit = Int64.max
        maxLimit = 0
        average = 0
        if type == "weight" {
            var sum : Int64 = 0
            for data in weightData {
                if (graphValues.count == 7) {
                    break
                }
                var convertedValue: Int64;
                if unitSegControl.selectedSegmentIndex == 0 {
                    convertedValue = data.unit == "lbs" ? data.value : Int64(Double(data.value) * 2.2);
                }
                else {
                    convertedValue = data.unit == "kg" ? data.value : Int64(Double(data.value) * 0.45);
                }
                sum += convertedValue
                maxLimit = max(maxLimit, convertedValue)
                minLimit = min(minLimit, convertedValue)
                graphValues.append(convertedValue)
            }
            graphValues.reverse()
            if (graphValues.count != 0) {
                average = sum / Int64(graphValues.count)
            }
        }
        else if type == "hand" {
            for data in handData {
                if (graphValues.count == 7) {
                    break
                }
                maxLimit = max(maxLimit, data.times)
                minLimit = min(minLimit, data.times)
                graphValues.append(data.times)
            }
            graphValues.reverse()
        }
    }
    
    // cite: demo project of charts framework
    func updateGraph() {
        chartView.chartDescription?.enabled = false
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: Double(average))
        ll1.lineWidth = 4
        ll1.lineDashLengths = [15, 15]
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        if type == "weight" {
            leftAxis.addLimitLine(ll1)
        }
        leftAxis.axisMaximum = Double(maxLimit + (type == "weight" ? 25 : 3))
        leftAxis.axisMinimum = Double(max(minLimit - (type == "weight" ? 25 : 3), 0))
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawLabelsEnabled = false
        
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.legend.form = .line
        chartView.animate(xAxisDuration: 0.5)
        
        chartView.frame = CGRect(x: 0, y: 75, width: self.view.frame.size.width * 0.95, height: 200)
        chartView.center.x = self.view.center.x
        view.addSubview(chartView)
        var graphEntries = [ChartDataEntry]()
        for i in 1..<graphValues.count + 1 {
            graphEntries.append(ChartDataEntry(x: Double(i), y: Double(graphValues[i - 1])))
        }
        let set1 = LineChartDataSet(entries: graphEntries, label: type == "weight" ? "Weight" : "Handwashing")
        set1.drawIconsEnabled = false
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = UIFont(name: "HelveticaNeue-Bold", size: 10) ?? .systemFont(ofSize: 10)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        let data = LineChartData(dataSet: set1)
        chartView.data = data
        if self.graphValues.count == 0 {
            let label = UILabel(frame: CGRect(x: 200, y: 160, width: 200, height: 20))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            label.text = "No data found"
            self.view.addSubview(label)
        }
    }
    
    @IBAction func changeUnit(_ sender: Any) {
        fetchData()
        updateGraph()
        dataTable.reloadData()
    }
    
    @IBAction func clickHealthApp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "x-apple-health://")!)
    }
}

extension DetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // for later: remove data
    }
}

extension DetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type == "weight" ? weightData.count : handData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableCell
        cell.dataImg.image = UIImage(named: "checked")
        if type == "weight" {
            let curData: WeightData = weightData[indexPath.row]
            var convertedValue: Int64;
            if unitSegControl.selectedSegmentIndex == 0 {
                convertedValue = curData.unit == "lbs" ? curData.value : Int64(Double(curData.value) * 2.2);
            }
            else {
                convertedValue = curData.unit == "kg" ? curData.value : Int64(Double(curData.value) * 0.45);
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            cell.dateLabel.text = dateFormatter.string(from: curData.date!)
            cell.valueLabel.text = "\(convertedValue) \(unitSegControl.selectedSegmentIndex == 0 ? "lbs" : "kg")"
        }
        else {
            let curData: HandWashData = handData[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            cell.dateLabel.text = dateFormatter.string(from: curData.date!)
            cell.valueLabel.text = "\(curData.times) time(s)"
        }
        return cell
    }
}
