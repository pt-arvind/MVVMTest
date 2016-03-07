//
//  ViewController.swift
//  MVVMTest
//
//  Created by Arvind Subramanian on 3/6/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import UIKit
import SnapKit

struct QuotesViewViewModel {
    let quoteText: String
    let quoteAuthor: String
    
    init(quote: Quote) {
        quoteText = quote.text
        quoteAuthor = "-- \(quote.author)"
    }
}

protocol QuoteDataSourceInterface {
    func nextQuote() -> QuotesViewViewModel
    func loadQuotes(quotes: [Quote])
}
final class QuoteDataSource : QuoteDataSourceInterface {
    var quotes = [QuotesViewViewModel]()
    
    func nextQuote() -> QuotesViewViewModel  {
        let max = UInt32(quotes.count)
        guard max > 0 else { fatalError("insufficient quotes!") }
        
        let randomIndex = Int(arc4random_uniform(max))
        return quotes[randomIndex]
    }
    
    func loadQuotes(quotes: [Quote]) {
        self.quotes = quotes.map({ (quote) -> QuotesViewViewModel in
            return QuotesViewViewModel(quote: quote)
        })
    }
}

protocol QuoteViewModelDelegate : class {
    func didLoadQuotes()
    func setupInitialConstraints()
    func setupActionHandling()
    func displayWithQuotesViewVM(vModel: QuotesViewViewModel)
    
    func styleButtons()
    func styleView()
    func styleNav()
}
class QuoteViewModel {
    weak var delegate: QuoteViewModelDelegate? // the VC
    var quoteExtractor: QuotesExtractor //the 'API'
    var dataSource: QuoteDataSourceInterface // the datasource
    
    init(delegate: QuoteViewModelDelegate, quoteExtractor: QuotesExtractor, dataSource: QuoteDataSourceInterface) {
        self.delegate = delegate
        self.quoteExtractor = quoteExtractor
        self.dataSource = dataSource
    }
    
    func navTitle() -> String {
        return "Inspirational Quotes!"
    }
    
    func isNavTranslucent() -> Bool {
        return false
    }
    
    func backgroundColor() -> UIColor {
        return .whiteColor()
    }
    
    func nextQuoteButtonTitleForState(state: UIControlState) -> String {
        if state == .Normal {
            return "Next Quote"
        }
        fatalError("unsupported state")
    }
    
    func viewDidLoad() {
        extractQuotes()
        delegate?.setupInitialConstraints()
        delegate?.setupActionHandling()
        delegate?.styleButtons()
        delegate?.styleNav()
        delegate?.styleView()
        delegate?.displayWithQuotesViewVM(initialQuote())
    }
    
    func extractQuotes(filename: String = "quotes") {
        let quotes = quoteExtractor.extractQuotesFromFile(filename)
        dataSource.loadQuotes(quotes)
        delegate?.didLoadQuotes()
    }
    
    func initialQuote() -> QuotesViewViewModel {
        return dataSource.nextQuote()
    }
    
    func nextQuote(button: UIButton) {
        delegate?.displayWithQuotesViewVM(dataSource.nextQuote())
    }
}


class ViewController: UIViewController {
    
    var viewModel: QuoteViewModel?
    
    lazy var quotesView: QuotesView = {
        let _quotesView = QuotesView()
        
        self.view.addSubview(_quotesView)
        return _quotesView
    }()
    
    lazy var nextQuoteButton: UIButton = {
        let button = UIButton(type: .System)
        self.view.addSubview(button)
        return button
    }()
    
    required init(dataSource: QuoteDataSource) {
        super.init(nibName: nil, bundle: nil)        
        self.viewModel = QuoteViewModel(delegate: self, quoteExtractor: QuotesManager.sharedManager, dataSource: dataSource)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { fatalError("nein") }
        viewModel.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuote(button: UIButton) { //alternative to doing this is make VM inherit from NSObject and then link the action directly there!
        guard let viewModel = viewModel else { fatalError("pass through") }
        viewModel.nextQuote(button)
    }
}


extension ViewController : QuoteViewModelDelegate {
    func didLoadQuotes() {
        
    }
    
    func styleButtons() {
        guard let viewModel = viewModel else { fatalError("bue-tonnes") }
        nextQuoteButton.setTitle(viewModel.nextQuoteButtonTitleForState(.Normal), forState: .Normal)
    }
    
    func styleView() {
        guard let viewModel = viewModel else { fatalError("view-tonnes") }
        view.backgroundColor = viewModel.backgroundColor()
    }
    
    func styleNav() {
        guard let viewModel = viewModel else { fatalError("lost at sea") }
        navigationItem.title = viewModel.navTitle()
        navigationController?.navigationBar.translucent = viewModel.isNavTranslucent()
    }
    
    func setupActionHandling() {
        nextQuoteButton.addTarget(self, action: "nextQuote:", forControlEvents: .TouchUpInside)
    }

    func displayWithQuotesViewVM(vModel: QuotesViewViewModel) {
        quotesView.setupWithDisplayObject(vModel)
    }
    
    func setupInitialConstraints() {
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
    }

}
