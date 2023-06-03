import Foundation

extension Indicators {
    var volatilities: [Volatility] {
        pairings.map { $0.volatility }
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
        history.prefix(days).map { $0.volume }.reduce(0, +) / days.asDouble
    }
    
    func avgVolumePreviousDay(_ days: Int = 24) -> Double {
        history.suffix(history.count-1).prefix(days).map { $0.volume }.reduce(0, +) / days.asDouble
    }
    
    func vwa(_ days: Int = 12) -> Double {
        security.volume / avgVolume(days)
    }
    
    //MARK: -- SMA
    func sma(_ days: Int = 12, context: Context) -> Double {
        let prefix = history.prefix(days)
        
        switch context {
        case .high:
            if prefix.count == days {
                return (prefix.map { $0.high }.reduce(0, +)) / days.asDouble
            } else {
                return (prefix.map { $0.high }.reduce(0, +)) / prefix.count.asDouble
            }
        case .close:
            if prefix.count == days {
                return (prefix.map { $0.value }.reduce(0, +)) / days.asDouble
            } else {
                return (prefix.map { $0.value }.reduce(0, +)) / prefix.count.asDouble
            }
        case .low:
            if prefix.count == days {
                return (prefix.map { $0.low }.reduce(0, +)) / days.asDouble
            } else {
                return (prefix.map { $0.low }.reduce(0, +)) / prefix.count.asDouble
            }
        }
    }
    
    func smaWA(_ days: Int = 24, context: Context) -> Double {
        security.value(forContext: context) / sma(days, context: context)
    }
    
    //MARK: -- EMA
    func ema(_ days: Int = 12, context: Context, limit: Int = 90, iter: Int = 0) -> Double {
        let firstOfHistoricalSecurities = history.first ?? security
        
        let indicatorsOfThePast = Indicators.init(firstOfHistoricalSecurities, quote: self.quote)
        
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
        
        var value: Double = security.value(forContext: context)
        
        var valueLast: Double = firstOfHistoricalSecurities.value(forContext: context)
        
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

extension Int {
    var asDouble: Double {
        Double(self)
    }
}

