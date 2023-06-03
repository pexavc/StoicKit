//
//  File.swift
//  
//
//  Created by PEXAVC on 4/12/21.
//

import Foundation
//MARK: -- DataSet without no sentiment
class SecurityDataSet {
    let security: Security
    
    var indicators: Indicators
    
    let change: Double
    
    let context: Indicators.Context

    init(quote: [Security],
         context: Indicators.Context = .close) {
        
        var quoteLastRemoved = quote
        let lastSecurity = quoteLastRemoved.removeLast() //most recent
        
        let indicators = Indicators.init(with: quoteLastRemoved)
        self.indicators = indicators
        self.security = lastSecurity
        self.change = (lastSecurity.value - indicators.security.value) / indicators.security.value
        self.context = context
    }

    public lazy var asArray: [Double] = {
        [
            indicators.emaWA(context: context),
            indicators.smaWA(context: context),
            indicators.basePair.volatility.volatility,
            indicators.basePair.volatility.momentum,
            indicators.basePair.volatility.change,
            indicators.vwa(),
        ]
    }()
    
    public func asArrayIMBHS(_ variant1: Indicators.Variant, _ variant2: Indicators.Variant, days1: Int, days2: Int, daysO: Int) -> ([Double]) {
        
        
        return ([
            variant1.compute(indicators, context: context, days: days1),
            variant2.compute(indicators, context: context, days: days2),
            Indicators.Variant.volatility.compute(indicators, context: context, days: daysO),
            Indicators.Variant.momentum.compute(indicators, context: context, days: daysO),
            Indicators.Variant.change.compute(indicators, context: context, days: daysO),
            Indicators.Variant.vwa.compute(indicators, context: context, days: daysO)
        ])
    }

    public var inDim: Int {
        asArray.count
    }

    public var outDim: Int {
        output.count
    }

    public var output: [Double] {
        [ security.value(forContext: context) ]
//        [ change ]
    }
    
    public var asString: String {
        """
        [\(indicators.security.dateAsString)]
        \(asArray)
        """
    }
}
