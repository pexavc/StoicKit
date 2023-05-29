//
//  Quote.swift
//  * stoic
//
//  Created by PEXAVC on 1/5/21.
//


import Foundation

public struct Quote {
    var ticker: String
    var securityType: SecurityType
    var exchangeName: String
    var name: String
    var securities: [Security] 
    var dailySecurities: [Security] {
        precomputedDailies ?? securities.dailies
    }
    var precomputedDailies: [Security]? = nil
    
    public init(ticker: String,
                securityType: SecurityType,
                exchangeName: String,
                name: String,
                securities: [Security]) {
        self.ticker = ticker
        self.securityType = securityType
        self.exchangeName = exchangeName
        self.name = name
        self.securities = securities
    }
    
    public mutating func precompute() {
        guard self.precomputedDailies == nil else { return }
        self.precomputedDailies = dailySecurities
    }
    
    var latestSecurity: Security {
        securities.sortDesc.first ?? EmptySecurity()
    }
    
    var tickerSymbol: String {
        latestSecurity.symbol
    }
    
    var latestChangePercent: Double {
        latestSecurity.changePercentValue
    }
    
    var latestChangeAbsolute: Double {
        latestSecurity.changeAbsoluteValue
    }
    
    var latestIsGainer: Bool {
        latestSecurity.isGainer
    }
    
    var latestValue: Double {
        latestSecurity.lastValue
    }
    
    public var quoteID: String {
        ticker+name
    }
    
    var needsUpdate: Bool {
        let noSecurities = securities.count < 4
        
        return latestSecurity.isNotLatest || noSecurities// && Date.today.validTradingDay) || securities.count < 4
    }
    
    var updateTime: Int? {
        let hours: Int = Date.today.hoursFrom(latestSecurity.date)
        let days = max(1, hours/24)
        return securities.count < 4 ? nil : days
    }
}

extension Quote {
    public func isEqual(to quote: Quote) -> Bool {
        return self.ticker == quote.ticker &&
            self.exchangeName == quote.exchangeName &&
            self.securityType == quote.securityType
    }
    
    public func contains(security: Security) -> Bool {
        return self.ticker == security.ticker &&
            self.name == security.name &&
            self.securityType == security.securityType
    }
}

extension Quote {
    func intraday(count: Int = 120) -> [Security] {
        let securities = self.securities.sortDesc
        return Array(securities.prefix(count))
    }
    
    func daily(count: Int = 120) -> [Security] {
        let securities = self.securities.sortDesc
        return Array(securities.prefix(count))
    }
}
