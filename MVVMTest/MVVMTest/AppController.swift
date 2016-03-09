//
//  AppController.swift
//  MVVMTest
//
//  Created by Arvind Subramanian on 3/7/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import UIKit

class AppController {
    let window:UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
    lazy var quotesManager = QuotesManager()
    
    lazy var rootNav: UINavigationController = { (root) in
        let nav = UINavigationController(rootViewController: root)
        return nav
    }(ViewController(viewModel: QuoteViewModel(quoteExtractor: self.quotesManager, dataSource: QuoteDataSource())))
    
    func start(didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window.rootViewController = rootNav
        
        window.makeKeyAndVisible()
        return true
    }
}