//
//  ChartCandleModelManager.swift
//  Stock
//
//  Created by Aleksandr on 18/05/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import UIKit

class ChartCandleModelManager: ChartBaseModelManager
{
    private var data: Array = Array<DBCandle>()
    
    override func createData()
    {
        if let candles = DBCandle.getAll()
        {
            data.append(contentsOf: candles)
            model.data = data
        }
    }
    
    override func updateData()
    {
        requests.tickerPair(Pair.btc_usd.rawValue) { [weak self] (data) in

            if let candle: DBCandle = DBCandle.add(data: data)
            {
                self?.data.append(candle)
                self?.model.data = self?.data
            }
        }
    }
}
