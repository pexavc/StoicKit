import Foundation

extension Indicators {
    public func macD(_ days: Int = 12, context: Context = .close) -> Double {
        let ema12 = ema(days, context: context) // 12
        let ema26 = ema(days + 14, context: context) // 24
        
//        print("{TEST} \(self.security.date) - ema12: \(ema12) // ema26: \(ema26)")
        return ema12 - ema26
    }
    
    public func macDAverage(_ days: Int = 12, context: Context = .close) -> Double {
        let ema12 = ema(days, context: context) // 12
        let ema26 = ema(days + 14, context: context) // 24
        
//        print("{TEST} \(self.security.date) - ema12: \(ema12) // ema26: \(ema26)")
        return (ema12 - ema26) / ema12
    }
    
    public func macDPrevious(context: Context = .close) -> Double {
        MacD.init([security] + history, quote: quote, context: context).values.macDs.first ?? 0.0
    }
    
    public func macDSignal(_ days: Int = 9, context: Context = .close) -> Double {
        MacD.init([security] + history, quote: quote, days: days, context: context).values.macDSignals.first ?? 0.0
    }
    
    public func macDPreviousSignal(context: Context = .close) -> Double {
        MacD.init(history, quote: quote, context: context).values.macDSignals.first ?? 0.0
    }
    
    public struct MacD {
        public struct Value {
            let dates: [Date]
            let macDs: [Double]
            let macDSignals: [Double]
            
            var toString: String {
                """
                📈📈📈📈📈📈
                [MacD - \(String(describing: dates.first?.asString))]
                macDs: \(macDs.first ?? 0.0)
                macDSignals: \(macDSignals.first ?? 0.0)
                📈
                """
            }
            var toStringDetailed: String {
                var stringD: String = ""
                for index in 0..<dates.count - 4 {
                    stringD+="\(dates[index].asString): \(macDs[index]) // \(macDSignals[index])\n"
                }
                
                return """
                📈📈📈📈📈📈
                [MacD]
                \(stringD)
                📈
                """
            }
            
            var count: Int {
                min(dates.count, min(macDs.count, macDSignals.count))
            }
        }
        
        public static func calculate(_ history: [Security],
                                     quote: [Security],
                                     context: Context,
                                     signal: Int = 9) -> MacD.Value {
            var securities = history
//            print("%%%%%%%%%%%%%%%%%%%%%%%%")
            var dates: [Date] = []
            var macDs: [Double] = []
            for _ in 0..<securities.count {
                
                let security = securities.removeFirst()
                let indicatorsOfThePast = Indicators.init(security, quote: quote)
                macDs.append(indicatorsOfThePast.macD(context: context))
                dates.append(security.date)
            }
            
            var macDSignals: [Double] = []
            let macDCount: Int = macDs.count
            for index in 0..<macDCount {
                
                /*
                 
                 MacD signal is a 9 day rolling mean of the EMA of those values
                 */
                
                var nextPeriod = macDs.suffix(macDCount - index).prefix(signal + 1)
                
                let currentMacD = nextPeriod.removeFirst()
                
                let sumOfPeriod = nextPeriod.reduce(0, +)
                let meanOfPeriod = sumOfPeriod/signal.asDouble
                
                let K: Double = 2/(Double(signal) + 1)
                
                let macDSignal = (currentMacD * K) + (meanOfPeriod * (1 - K))
                
                //
                macDSignals.append(macDSignal)
            }
            
            return .init(dates: dates,
                         macDs: macDs,
                         macDSignals: macDSignals)
        }
        
        let values: Value
        public init(_ history: [Security], quote: [Security], days: Int = 9, context: Context) {
            self.values = MacD.calculate(history, quote: quote, context: context, signal: days)
        }
    }
}
