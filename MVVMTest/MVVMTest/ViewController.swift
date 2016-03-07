//
//  ViewController.swift
//  MVVMTest
//
//  Created by Arvind Subramanian on 3/6/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import UIKit
import SnapKit

struct QuoteDisplayObject {
    let quoteText: String
    let quoteAuthor: String
    
    init(quote: Quote) {
        quoteText = quote.text
        quoteAuthor = "-- \(quote.author)"
    }
}


final class QuoteDataSource {
    var quotes = [QuoteDisplayObject]()
    
    func nextQuote() -> QuoteDisplayObject  {
        let max = UInt32(quotes.count)
        guard max > 0 else { fatalError("insufficient quotes!") }
        
        let randomIndex = Int(arc4random_uniform(max))
        return quotes[randomIndex]
    }
    
    init(quotes: [Quote]) {
        loadQuotes(quotes)
    }
    
    func loadQuotes(quotes: [Quote]) {
        self.quotes = quotes.map({ (quote) -> QuoteDisplayObject in
            return QuoteDisplayObject(quote: quote)
        })
    }
    
}

class ViewController: UIViewController {
    
    var dataSource: QuoteDataSource?
    
    lazy var quotesView: QuotesView = {
        let _quotesView = QuotesView()
        
        self.view.addSubview(_quotesView)
        return _quotesView
    }()
    
    lazy var nextQuoteButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Next Quote", forState: .Normal)
        
        self.view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Inspirational Quotes!"
        navigationController?.navigationBar.translucent = false
        
        quotesView.snp_updateConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.height.equalTo(view).dividedBy(3)
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        nextQuoteButton.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(quotesView.snp_bottom).offset(30)
            make.centerX.equalTo(view)
        }
        
        view.backgroundColor = .whiteColor()
        
        let quotes = QuotesManager.extractQuotesFromFile("quotes")
        dataSource = QuoteDataSource(quotes: quotes)
        
        quotesView.setupWithDisplayObject(dataSource!.nextQuote())
        
        nextQuoteButton.addTarget(self, action: "nextQuote", forControlEvents: .TouchUpInside)
    }
    
    func nextQuote() {
        guard let dataSource = dataSource else { return }
        quotesView.setupWithDisplayObject(dataSource.nextQuote())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

