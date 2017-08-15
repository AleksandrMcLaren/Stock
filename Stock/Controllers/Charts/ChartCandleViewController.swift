//
//  SKChartViewController.swift
//  Stock
//
//  Created by Aleksandr on 27/04/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import UIKit
import Charts

class ChartCandleViewController: UIViewController, ChartViewControllerProtocol, ChartViewDelegate {

    // MARK: - Properties
    
    fileprivate let chartView: CandleStickChartView = CandleStickChartView()

    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        configureChartView()
        view.addSubview(chartView)
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    
        chartView.frame = view.bounds
    }
    
    // MARK: - Configure Chart view
    
    func configureChartView()
    {
        chartView.backgroundColor = .white
        chartView.delegate = self
        chartView.chartDescription?.enabled = true
        chartView.pinchZoomEnabled = true
        chartView.drawGridBackgroundEnabled = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = XAxis.LabelPosition(rawValue: 1)!
        xAxis.drawGridLinesEnabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.gridColor = .lightGray
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        
        setDefaultChartDescription()
    }

    func setDefaultChartDescription()
    {
        chartView.chartDescription?.text = "Candle description"
    }
    
    // MARK: - Data
    
    func reloadData(_ data: Array<Any>)
    {
        guard let data = data as? Array<DBCandle> else
        {
            return
        }

        if data.count == 0
        {
            DispatchQueue.main.async {
                self.chartView.data = nil
            }
            
            return
        }
        
        var yVals1 = [CandleChartDataEntry]()

        for i in 0..<data.count
        {
            let candle = data[i]
            let candleData: CandleChartDataEntry = CandleChartDataEntry.init(x: Double(i), shadowH: candle.high, shadowL: candle.low, open: candle.open, close: candle.close)
            yVals1.append(candleData)
        }
        
        let set1: CandleChartDataSet = CandleChartDataSet.init(values: yVals1, label: "Candles")
        set1.shadowColor = .black
        set1.shadowWidth = 0.7
        set1.decreasingColor = UIColor(red:0.91, green:0.14, blue:0.12, alpha:1.00)
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red:0.16, green:0.73, blue:0.15, alpha:1.00)
        set1.increasingFilled = true
        set1.neutralColor = .black
        
        let chartData: CandleChartData = CandleChartData.init(dataSet: set1)
        
        DispatchQueue.main.async {
            self.chartView.data = chartData
        }
    }
    
    // MARK: - ChartViewDelegate
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        if let candleChartData: CandleChartDataEntry = entry as? CandleChartDataEntry
        {
            chartView.chartDescription?.text = "low: \(candleChartData.low), hight: \(candleChartData.high), open: \(candleChartData.open), close: \(candleChartData.close)"
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        setDefaultChartDescription()
    }
}
