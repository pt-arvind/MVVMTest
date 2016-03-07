//
//  Quote.swift
//  MVVMTest
//
//  Created by Arvind Subramanian on 3/6/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import Foundation

final class QuoteHelper {
    static let kAnonymous = "Anonymous"
    static func validateAuthor(author: String?) -> String {
        if let author = author where author != "" {
            return author
        } else {
            return kAnonymous
        }
    }
}

final class QuoteFactory {
    static func makeQuote(text: String, author: String?, timeOfDay: TimeOfDay) -> Quote {
        return Quote(text: text, author: QuoteHelper.validateAuthor(author), timeOfDay: timeOfDay)
    }
}

enum TimeOfDay : String {
    case Morning = "morning"
    case Noon = "noon"
    case Afternoon = "afternoon"
    case Evening = "evening"
    case Night = "night"
    
    static func allValues() -> [TimeOfDay] {
        return [.Morning, .Noon, .Afternoon, .Evening, .Night]
    }
}

struct Quote : CustomDebugStringConvertible {
    let text: String
    let author: String
    let timeOfDay: TimeOfDay
    
    var debugDescription: String {
        return "\(text) -- \(author) should show up at: \(timeOfDay.rawValue)"
    }
    
    private init(text: String, author: String, timeOfDay: TimeOfDay) {
        self.text = text
        self.author = author
        self.timeOfDay = timeOfDay
    }
}






