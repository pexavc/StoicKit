//
//  Cryptocurrency.swift
//  * stoic (iOS)
//
//  Created by PEXAVC on 12/21/20.
//

import Foundation

public struct CryptoCurrency: Security, Equatable, Codable  {
    public var ticker: String
    public var date: Date
    public var open: Double
    public var close: Double
    public var high: Double
    public var low: Double
    public var volumeBTC: Double
    public var volume: Double
    public var changePercent: Double
    public var changeAbsolute: Double
    public var interval: SecurityInterval
    public var exchangeName: String
    public var name: String
    public var hasStrategy: Bool
    public var hasPortfolio: Bool
}

extension CryptoCurrency {
    public var indicator: String {
        "₿"
    }
    
    public var securityType: SecurityType {
        .crypto
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
}
