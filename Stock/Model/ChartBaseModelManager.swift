//
//  ChartBaseModelManager.swift
//  Stock
//
//  Created by Aleksandr on 28/04/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import UIKit


class ChartBaseModelManager : NSObject
{
    // MARK: - Properties
    
    let model: ChartModel = ChartModel()
    var requestTimer: Timer?
    let requests = Requests()
    
    // MARK: - Manage life cycle Timer
    
    func startUpdate()
    {
        requestTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        requestTimer?.fire()

        createData()
    }
    
    func stopUpdate()
    {
        requestTimer?.invalidate()
        requestTimer = nil
    }
    
    // MARK: - Needs override
    
    func createData(){}
    
    func updateData(){}
}
