//
//  TonalService.Indicators.Averages.swift
//  * stoic
//
//  Created by PEXAVC on 1/5/21.
//

import Foundation

extension StoicKit.Indicators {
    var volatilities: [Volatility] {
        historyPaired.map { $0.volatility }
    }
    
    func slicedVolatilities(_ days: Int = 4) -> [Volatility] {
        Array(volatilities.prefix(days))
    }
    
    //MARK: -- Momentum
    func avgMomentum(_ days: Int = 120) -> Double {
        slicedVolatilities(days).map { $0.momentum }.reduce(0, +) / days.asDouble
    }
    
    func avgVolMomentum(_ days: Int = 120) -> Double {
        slicedVolatilities(days).map { $0.volMomentum }.reduce(0, +) / days.asDouble
    }
    
    //MARK: -- Volatility
    func avgVolatility(_ days: Int = 12) -> Double {
        slicedVolatilities(days).map { $0.volatility }.reduce(0, +) / days.asDouble
    }
    
    func avgVolVolatility(_ days: Int = 12) -> Double {
        slicedVolatilities(days).map { $0.volumeVolatiliy }.reduce(0, +) / days.asDouble
    }
    
    //MARK: -- Change
    func avgChange(_ days: Int = 4) -> Double {
        slicedVolatilities(days).map { $0.change }.reduce(0, +) / days.asDouble
    }
    
    //MARK: -- Volume
    func avgVolChange(_ days: Int = 4) -> Double {
        slicedVolatilities(days).map { $0.volumeChange }.reduce(0, +) / days.asDouble
    }
    
    func avgVolume(_ days: Int = 12) -> Double {
        history.prefix(days).map { $0.volumeValue }.reduce(0, +) / days.asDouble
    }
    
    func avgVolumePreviousDay(_ days: Int = 24) -> Double {
        history.suffix(history.count-1).prefix(days).map { $0.volumeValue }.reduce(0, +) / days.asDouble
    }
    
    func vwa(_ days: Int = 12) -> Double {
        security.volumeValue / avgVolume(days)
    }
    
    //MARK: -- SMA
    func sma(_ days: Int = 12, context: Context) -> Double {
        let prefix = history.prefix(days)
        
        switch context {
        case .high:
            if prefix.count == days {
                return (prefix.map { $0.highValue }.reduce(0, +)) / days.asDouble
            } else {
                return (prefix.map { $0.highValue }.reduce(0, +)) / prefix.count.asDouble
            }
        case .close:
            if prefix.count == days {
                return (prefix.map { $0.lastValue }.reduce(0, +)) / days.asDouble
            } else {
                return (prefix.map { $0.lastValue }.reduce(0, +)) / prefix.count.asDouble
            }
        case .low:
            if prefix.count == days {
                return (prefix.map { $0.lowValue }.reduce(0, +)) / days.asDouble
            } else {
                return (prefix.map { $0.lowValue }.reduce(0, +)) / prefix.count.asDouble
            }
        }
    }
    
    func smaWA(_ days: Int = 24, context: Context) -> Double {
        security.value(forContext: context) / sma(days, context: context)
    }
    
    //MARK: -- EMA
    func ema(_ days: Int = 12, context: Context, limit: Int = 90, iter: Int = 0) -> Double {
        let firstOfHistoricalSecurities = history.first ?? security
        
        let indicatorsOfThePast = StoicKit.Indicators.init(firstOfHistoricalSecurities, with: self.history)
        
        if iter >= days {
            //We start with an SMA base case
            return indicatorsOfThePast.sma(days, context: context)
        }
        /**
         
         EMA=(closing price − previous day’s EMA)× smoothing constant as a decimal + previous day’s EMA
                    "previous day's EMA  == previous day's SMA".... lol
         
         EMA = (today’s closing price *K) + (Previous EMA * (1 – K))
         
                smoothing constant = 2/days + 1 aka 2/time periods + 1
         
            
         */
        
        var value: Double {
            switch context {
            case .high:
                return security.highValue
            case .close:
                return security.lastValue
            case .low:
                return security.lowValue
            }
        }
        
        var valueLast: Double {
            switch context {
            case .high:
                return firstOfHistoricalSecurities.highValue
            case .close:
                return firstOfHistoricalSecurities.lastValue
            case .low:
                return firstOfHistoricalSecurities.lowValue
            }
        }
        
        let prevEMA_aka_SMA = indicatorsOfThePast.ema(days, context: context, iter: iter + 1)
        let x1 = value - prevEMA_aka_SMA
        let K: Double = log10(value/valueLast)//2/(days + 1)
        let y1 = prevEMA_aka_SMA

        let emaValue = (x1 * K) + prevEMA_aka_SMA//(y1 * (1 - K))
        
        return emaValue
    }
    
    func emaWA(_ days: Int = 24, context: Context) -> Double {
        security.value(forContext: context) / ema(days, context: context)
    }
}

extension Security {
    var dayAverage: Double {
        return (self.highValue + self.lowValue) / 2
    }
}

extension StoicKit.Indicators {
    var averagesToString: String {
        """
        %%%%%%%%%%%%%
        Comparing To: \(history.first?.date.asString ?? "error")
        avgMomentum: \(avgMomentum())
        avgVolatility: \(avgVolatility())
        avgChange: \(avgChange())
        avgVolume: \(avgVolume())
        avgVolMomentum: \(avgVolMomentum())
        avgVolVolatility: \(avgVolVolatility())
        avgVolumeChange: \(avgVolChange())
        vwa: \(vwa())
        """
    }
    
    
//    sma12: \(sma(12))
//    sma20: \(sma(20))
//    sma24: \(sma(24))
//    smaWA24_Close: \(smaWA(context: .close))
//    sma200: \(sma(200))
//    ema: \(ema())
//    emaWA: \(emaWA())
//    macD: \(macD())
}
