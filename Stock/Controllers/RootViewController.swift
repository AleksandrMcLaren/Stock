//
//  RootViewController.swift
//  Stock
//
//  Created by Aleksandr on 04/05/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import UIKit

class RootViewController: UIViewController
{
    // MARK: - Properties
    
    private let mainVC: MainViewController = MainViewController()
    
    // MARK: - Life cycle
    
    static let shared: RootViewController = RootViewController()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(mainVC.view)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        let boundsSize = view.bounds.size
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        mainVC.view.frame = CGRect(x: 0, y: statusBarHeight, width: boundsSize.width, height: boundsSize.height - statusBarHeight)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Open Chart
    
    fileprivate func openChart<T: UIViewController>(_ chartVC: T, modelManager: ChartBaseModelManager) where T: ChartViewControllerProtocol
    {
        mainVC.setChartVC(chartVC, modelManager: modelManager)
    }
    
    // MARK: - Navigation methods
    
    func showNavigationBar()
    {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func pushViewController(_ vc: UIViewController)
    {
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RootViewController
{
    func openChartCandle()
    {
        let modelManager = ChartCandleModelManager()
        let chartVC = ChartCandleViewController()
        openChart(chartVC, modelManager: modelManager)
    }
}
