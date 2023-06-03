//
//  DataSet.swift
//  AIToolbox
//
//  Created by Kevin Coble on 12/6/15.
//  Copyright © 2015 Kevin Coble. All rights reserved.
//

import Foundation

public class MetaData: Codable {
    let nextTradingDate: String
    let daysTrained: String
    let sentimentStrength: String
    
    public init(nextTradingDate : String, daysTrained : String, sentimentStrength : String)
    {
        self.nextTradingDate = nextTradingDate
        self.daysTrained = daysTrained
        self.sentimentStrength = sentimentStrength
    }
    
    enum CodingKeys: String, CodingKey {
        case nextTradingDate
        case daysTrained
        case sentimentStrength
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nextTradingDate: String = try container.decode(String.self, forKey: .nextTradingDate)
        let daysTrained: String = try container.decode(String.self, forKey: .daysTrained)
        let sentimentStrength: String = try container.decode(String.self, forKey: .sentimentStrength)

    
        self.init(
            nextTradingDate: nextTradingDate,
            daysTrained: daysTrained,
            sentimentStrength: sentimentStrength)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(nextTradingDate, forKey: .nextTradingDate)
        try container.encode(daysTrained, forKey: .daysTrained)
        try container.encode(sentimentStrength, forKey: .sentimentStrength)
    }
    
}
