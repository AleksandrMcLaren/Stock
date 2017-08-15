//
//  SKMainViewController.swift
//  Stock
//
//  Created by Aleksandr on 27/04/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import UIKit

class MainViewController: UIViewController
{
    // MARK: - Properties
    
    fileprivate var chartVC: UIViewController?
    @objc fileprivate var modelManager: ChartBaseModelManager?
    fileprivate let tradeButton: UIButton = UIButton()

    // MARK: - Life cycle

    deinit
    {
        removeDataObserver()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .white

        tradeButton.backgroundColor = .darkGray
        tradeButton.setTitle("Trade", for: UIControlState.normal)
        tradeButton.addTarget(self, action: #selector(tradeButtonTouch), for: UIControlEvents.touchUpInside)
        view.addSubview(tradeButton)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        let boundsSize: CGSize = view.frame.size
        var tradeButtonHeight: CGFloat = 50

        if UIApplication.shared.statusBarOrientation != UIInterfaceOrientation.portrait
        {
            tradeButtonHeight = 40
        }
        
        chartVC?.view.frame = CGRect(x: 0, y: 0, width: boundsSize.width, height: boundsSize.height - tradeButtonHeight)
        tradeButton.frame = CGRect(x: 0, y: boundsSize.height - tradeButtonHeight, width: boundsSize.width, height: tradeButtonHeight)
    }

    // MARK: - Actions

    func tradeButtonTouch()
    {
        let vc: TradeViewController = TradeViewController()
        RootViewController.shared.pushViewController(vc)
        RootViewController.shared.showNavigationBar()
    }
    
    // MARK: - Change chart
    
    func setChartVC<T: UIViewController>(_ chartVC: T, modelManager: ChartBaseModelManager) where T: ChartViewControllerProtocol
    {
        self.modelManager?.stopUpdate()
        removeDataObserver()
        
        self.chartVC?.view.removeFromSuperview()
        
        self.chartVC = chartVC
        self.modelManager = modelManager
        view.addSubview(self.chartVC!.view)
        view.setNeedsLayout()
        
        addDataObserver()
        self.modelManager!.startUpdate()
    }
    
    // MARK: - Key-Value Observing
    
    func addDataObserver()
    {
        addObserver(self, forKeyPath: #keyPath(modelManager.model.data), options: [.new], context: nil)
    }
    
    func removeDataObserver()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == #keyPath(modelManager.model.data)
        {
            if let newValue = change?[.newKey] as? Array<Any>
            {
                if let chart = self.chartVC as? ChartViewControllerProtocol
                {
                    chart.reloadData(newValue)
                }
            }
        }
    }
}
