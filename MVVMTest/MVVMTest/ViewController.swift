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

    var quotesView: QuotesView { get } // the view
    var nextQuoteButton: UIButton { get }
}
class QuoteViewModel : NSObject {
    weak var delegate: QuoteViewModelDelegate? // the VC
    
    var quoteExtractor: QuotesExtractor //the 'API'
    var dataSource: QuoteDataSourceInterface // the datasource
    
    init(delegate: QuoteViewModelDelegate? = nil, quoteExtractor: QuotesExtractor, dataSource: QuoteDataSourceInterface) {
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
    
    func extractQuotes(filename: String = "quotes") {
        let quotes = quoteExtractor.extractQuotesFromFile(filename)
        dataSource.loadQuotes(quotes)
        delegate?.didLoadQuotes()
    }

    func initialQuoteValues() -> (quote: String, author: String) {
        let quote = dataSource.nextQuote()
        return (quote:quote.quoteText, author:quote.quoteAuthor)
    }
    
    
    func nextQuote(button: UIButton) {
        displayWithQuotesViewVM(dataSource.nextQuote())
    }
    
    func displayWithQuotesViewVM(vModel: QuotesViewViewModel) {
        delegate?.quotesView.quoteLabel.text = vModel.quoteText
        delegate?.quotesView.creatorLabel.text = vModel.quoteAuthor
    }
}

class ViewController: UIViewController{
    
    let viewModel: QuoteViewModel
    
    lazy var quotesView: QuotesView = {
        let _quotesView = QuotesView()
        let initialValues = self.viewModel.initialQuoteValues()
        _quotesView.quoteLabel.text = initialValues.quote
        _quotesView.creatorLabel.text = initialValues.author

        self.view.addSubview(_quotesView)
        return _quotesView
    }()
    
    lazy var nextQuoteButton: UIButton = {
        let button = UIButton(type: .System)

        button.setTitle(self.viewModel.nextQuoteButtonTitleForState(.Normal), forState: .Normal)
        button.addTarget(self.viewModel, action: "nextQuote:", forControlEvents: .TouchUpInside)

        self.view.addSubview(button)
        return button
    }()
    
    required init(viewModel: QuoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func viewDidLayoutSubviews() {
        setupInitialConstraints()
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = viewModel.backgroundColor()
        navigationItem.title = viewModel.navTitle()
        navigationController?.navigationBar.translucent = viewModel.isNavTranslucent()

        viewModel.extractQuotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuote(button: UIButton) { //alternative to doing this is make VM inherit from NSObject and then link the action directly there!
        viewModel.nextQuote(button)
    }
}


extension ViewController : QuoteViewModelDelegate {
    func didLoadQuotes() {
        
    }
}