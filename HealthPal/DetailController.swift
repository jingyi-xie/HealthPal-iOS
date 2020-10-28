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
    var chartView = LineChartView()
    var weightData = [WeightData]()
    var handData = [HandWashData]()
    var graphValues = [ChartDataEntry]()
    var maxLimit: Int = 0
    var minLimit: Int = 0
    var average: Double = 0
    var type: String = "weight"
    
    // context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.delegate = self
        unitSegControl.isHidden = type == "hand"
        fetchData()
        updateGraph()
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
        if type == "weight" {
            
        }
        else if type == "hand" {
           
        }
    }
    
    // cite: demo project of charts framework
    func updateGraph() {
        chartView.chartDescription?.enabled = false
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: average, label: "Average")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .topRight
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.axisMaximum = Double(maxLimit)
        leftAxis.axisMinimum = Double(minLimit)
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawLabelsEnabled = false
        
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.legend.form = .line
        chartView.animate(xAxisDuration: 1)
        
        chartView.frame = CGRect(x: 0, y: 75, width: self.view.frame.size.width, height: 200)
        view.addSubview(chartView)
        
        let set1 = LineChartDataSet(entries: graphValues)
        set1.drawIconsEnabled = false
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
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
    }
    
    @IBAction func changeUnit(_ sender: Any) {
        fetchData()
        updateGraph()
    }
    
    @IBAction func clickHealthApp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "x-apple-health://")!)
    }
    
}
