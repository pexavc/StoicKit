//
//  Stock.swift
//  * stoic (iOS)
//
//  Created by PEXAVC on 12/21/20.
//

import Foundation

public struct Stock: Security, Equatable, Codable {
    public var ticker: String
    public var date: Date
    public var open: Double
    public var high: Double
    public var low: Double
    public var close: Double
    public var volume: Double
    public var changePercent: Double
    public var changeAbsolute: Double
    public var interval: SecurityInterval
    public var exchangeName: String
    public var name: String
    public var hasStrategy: Bool
    public var hasPortfolio: Bool
}

extension Stock {
    public var indicator: String {
        "$"
    }
    
    public var securityType: SecurityType {
        .stock
    }
    
    public var lastValue: Double {
        close
    }
    
    public var highValue: Double {
        high
    }
    
    public var lowValue: Double {
        low
    }
    
    public var volumeValue: Double {
        volume
    }
    
    public var changePercentValue: Double {
        changePercent
    }
    
    public var changeAbsoluteValue: Double {
        changeAbsolute
    }
    
    public var metadata1: String {
        self.name
    }
    
    public var metadata2: String {
        self.exchangeName
    }
}

//MARK: -- Extensions

//extension StockData {
//    public var asStock: Stock {
//        return .init(
//            ticker: symbolName,
//            date: dateData.asDate ?? Date(),
//            open: open,
//            high: high,
//            low: low,
//            close: close,
//            volume: volume,
//            changePercent: (close - lastStockData.close) / close,
//            changeAbsolute: (close - lastStockData.close))
//    }
//}
