//
//  QuotesManager.swift
//  MVVMTest
//
//  Created by Arvind Subramanian on 3/6/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation

typealias QuoteDict = [String : String]

protocol QuotesExtractor : class {
    func extractQuotesFromFile(fileName: String) -> [Quote]
}
final class QuotesManager : QuotesExtractor {
    static let sharedManager = QuotesManager()
    
    func extractQuotesFromFile(fileName: String) -> [Quote] {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist"), let quoteDicts = NSArray(contentsOfFile: path) as? [QuoteDict] else {
            fatalError("couldn't load file: \(fileName). Path may not exist in main bundle.")
        }
        return QuotesParser.quotesFromDictionaries(quoteDicts)
    }
}

// FIXME
final class QuotesSerializer {
    static func dictionariesFromQuotes(quotes: [Quote]) -> [QuoteDict] {
        var quoteDicts = [QuoteDict]()
        
        for quote in quotes {
            quoteDicts.append(dictionaryFromQuote(quote))
        }
        
        return quoteDicts
    }
    
    static func dictionaryFromQuote(quote: Quote) -> QuoteDict {
        var quoteDict = [String:String]()
        quoteDict["text"] = quote.text
        quoteDict["author"] = quote.author
        quoteDict["timeframe"] = quote.timeOfDay.rawValue
        return quoteDict
    }
}

// FIXME
final class QuotesParser {
    static func quotesFromDictionaries(quoteDicts: [QuoteDict]) -> [Quote] {
        var quotes = [Quote]()
        
        for quoteDict in quoteDicts {
            if let quote = quoteFromDictionary(quoteDict) {
                quotes.append(quote)
            }
        }
        
        return quotes
    }
    
    static func quoteFromDictionary(quoteDict: QuoteDict) -> Quote? {
        guard let text = quoteDict["text"], timeframe = quoteDict["timeframe"], timeOfDay = TimeOfDay(rawValue: timeframe) else { return nil }
        let author = quoteDict["author"]
        
        return QuoteFactory.makeQuote(text, author: author, timeOfDay: timeOfDay)
    }
}
