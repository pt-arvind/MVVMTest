//
//  QuotesViewModelSpec.swift
//  MVVMTest
//
//  Created by Arvind Subramanian on 3/7/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MVVMTest

struct DummyQuoteVMDelegateState {
    var didLoadQuotes: Bool?
    var styleButtons: Bool?
    var styleView: Bool?
    var styleNav: Bool?
    var setupActionHandling: Bool?
    var displayWithQuotesViewVM: Bool?
    var setupInitialConstraints: Bool?
}
class DummyQuoteVMDelegate : QuoteViewModelDelegate {
    var state = DummyQuoteVMDelegateState()
    
    func didLoadQuotes() {
        state.didLoadQuotes = true
    }
    
    func styleButtons() {
        state.styleButtons = true
    }
    
    func styleView() {
        state.styleView = true
    }
    
    func styleNav() {
        state.styleNav = true
    }
    
    func setupActionHandling() {
        state.setupActionHandling = true
    }
    
    func displayWithQuotesViewVM(vModel: QuotesViewViewModel) {
        state.displayWithQuotesViewVM = true
    }
    
    func setupInitialConstraints() {
        state.setupInitialConstraints = true
    }
}

struct DummyQuotesExtractorState {
    var extractQuotesFromFile: Bool?
}
class DummyQuotesExtractor : QuotesExtractor {
    var state = DummyQuotesExtractorState()
    func extractQuotesFromFile(fileName: String) -> [Quote] {
        state.extractQuotesFromFile = true
        return []
    }
}

struct DummyQuoteDataSourceInterfaceState {
    var nextQuote: Bool?
    var loadQuotes: Bool?
}
class DummyQuoteDataSourceInterface : QuoteDataSourceInterface {
    var state = DummyQuoteDataSourceInterfaceState()
    func nextQuote() -> QuotesViewViewModel {
        state.nextQuote = true
        return QuotesViewViewModel(quote: Quote(text:"",author:"", timeOfDay:TimeOfDay.Morning))
    }
    
    func loadQuotes(quotes: [Quote]) {
        state.loadQuotes = true
    }
}

struct QuoteViewModelTestHelper {
    var dummyDataSource = DummyQuoteDataSourceInterface()
    var dummyExtractor = DummyQuotesExtractor()
    var dummyDelegate = DummyQuoteVMDelegate()
    
}
class QuoteViewModelSpec: QuickSpec {
    var testHelper = QuoteViewModelTestHelper()
    override func spec() {

        beforeEach {
            self.testHelper = QuoteViewModelTestHelper() //should clear it all out
        }
        afterEach {
            
        }
        
        describe("viewModel's interactions with delegate") {
            it("notifies the delegate when view did load", closure: {  //we make sure that the side-effects of loading a view are shown!
                let viewModel = QuoteViewModel(delegate: self.testHelper.dummyDelegate, quoteExtractor: self.testHelper.dummyExtractor, dataSource: self.testHelper.dummyDataSource)
                
                viewModel.viewDidLoad()
                expect(self.testHelper.dummyDelegate.state.setupInitialConstraints).to(beTrue())
                expect(self.testHelper.dummyDelegate.state.didLoadQuotes).to(beTrue())
                expect(self.testHelper.dummyDelegate.state.styleButtons).to(beTrue())
                expect(self.testHelper.dummyDelegate.state.styleNav).to(beTrue())
                expect(self.testHelper.dummyDelegate.state.styleView).to(beTrue())
                expect(self.testHelper.dummyDelegate.state.styleButtons).to(beTrue())
                expect(self.testHelper.dummyDelegate.state.displayWithQuotesViewVM).to(beTrue())
            })
            
            it("can get the next quote") {
                let viewModel = QuoteViewModel(delegate: self.testHelper.dummyDelegate, quoteExtractor: self.testHelper.dummyExtractor, dataSource: self.testHelper.dummyDataSource)
                
                viewModel.nextQuote(UIButton())
                expect(self.testHelper.dummyDelegate.state.displayWithQuotesViewVM).to(beTrue())
            }
            
            it("should tell delegate when quotes have been loaded") {
                let viewModel = QuoteViewModel(delegate: self.testHelper.dummyDelegate, quoteExtractor: self.testHelper.dummyExtractor, dataSource: self.testHelper.dummyDataSource)
                viewModel.extractQuotes()
                expect(self.testHelper.dummyDelegate.state.didLoadQuotes).to(beTrue())
            }
        }
        
        describe("viewModel's nav styling") {
            let viewModel = QuoteViewModel(delegate: self.testHelper.dummyDelegate, quoteExtractor: self.testHelper.dummyExtractor, dataSource: self.testHelper.dummyDataSource)
            it("sets the correct title") {
                expect(viewModel.navTitle()).to(equal("Inspirational Quotes!"))
            }
            
            it("sets the right bar translucency") {
                expect(viewModel.isNavTranslucent()).to(beFalse())
            }
        }
        
        describe("viewModel's background color for the view controller's view") {
            let viewModel = QuoteViewModel(delegate: self.testHelper.dummyDelegate, quoteExtractor: self.testHelper.dummyExtractor, dataSource: self.testHelper.dummyDataSource)
            it("should have the correct color") {
                expect(viewModel.backgroundColor()).to(equal(UIColor.whiteColor()))
            }
        }
        
        describe("viewModel's button") {
            let viewModel = QuoteViewModel(delegate: self.testHelper.dummyDelegate, quoteExtractor: self.testHelper.dummyExtractor, dataSource: self.testHelper.dummyDataSource)

            it("should have the right title for the normal control state") {
                expect(viewModel.nextQuoteButtonTitleForState(.Normal)).to(equal("Next Quote"))
            }
        }
        
    }
}

