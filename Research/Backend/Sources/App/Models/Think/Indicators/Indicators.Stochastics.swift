import Foundation

extension Indicators {
    public enum Variant {
        case smawa
        case emawa
        case macd
        case macdsignal
        case volchange
        case stochd
        case stochk
        case volatility
        case momentum
        case change
        case vwa
        
        func compute(_ ind: Indicators, context: Indicators.Context, days: Int) -> Double {
            switch self {
            case .smawa:
                return ind.smaWA(days, context: context)
            case .emawa:
                return ind.emaWA(days, context: context)
            case .macd:
                return ind.macDAverage(days, context: context)
            case .macdsignal:
                return ind.macDSignal(days, context: context)
            case .volchange:
                return ind.avgVolChange(days)
            case .stochd:
                return ind.stochastic.values.percentDs.first ?? 0.0
            case .stochk:
                return ind.stochastic.values.percentKs.first ?? 0.0
            case .volatility:
                return ind.avgChange(days) + 1
            case .momentum:
                return ind.avgMomentum(days) + 1
            case .change:
                return ind.basePair.volatility.change
            case .vwa:
                return ind.vwa()
            
            }
        }
    }
    
    // Indicators
    var stochastic: Stochastics {
        .init([security] + history)
    }
    
    var stochasticPreviousDay: Stochastics {
        .init(history)
    }
    
    public struct Stochastics {
        public struct Value {
            let dates: [Date]
            let percentKs: [Double]
            let percentDs: [Double]
            
            var absoluteKs: [Double] {
                percentKs.map { $0 * 100 }
            }
            
            var absoluteDs: [Double] {
                percentDs.map { $0 * 100 }
            }
            
            var toString: String {
                """
                📈📈📈📈📈📈
                [Stochastics - \(String(describing: dates.first?.asString))]
                percentK: \(percentKs.first ?? 0.0)
                percentD: \(percentDs.first ?? 0.0)
                📈
                """
            }
            var toStringDetailed: String {
                var stringD: String = ""
                for index in 0..<dates.count - 4 {
                    stringD+="\(dates[index].asString): \(percentKs[index]) // \(percentDs[index])\n"
                }
                
               return """
                📈📈📈📈📈📈
                [Stochastics]
                \(stringD)
                📈
                """
            }
            
            var count: Int {
                min(dates.count, min(percentKs.count, percentDs.count))
            }
        }
        
        public static func calculate(_ history: [Security],
                                     periods: Int = 14) -> Stochastics.Value {
            var securities = history
            
            var dates: [Date] = []
            var percentKs: [Double] = []
            for _ in 0..<securities.count {
                let security = securities.removeFirst()
                
                let lastPeriod = [security] + securities.prefix(periods - 1)
                
                guard lastPeriod.count == periods else { continue }
                
                let highestOfHighs = lastPeriod.map { $0.high }.max() ?? 0.0
                let lowestOfLows = lastPeriod.map { $0.low }.min() ?? 0.0
                
                /*
                 
                 A normal K Period is 14 days... we are using 12
                 
                          (latest_close - Lowest_Kperiod)
                  %K  =       ---------------------- x 100
                        (Highest_Kperiod) - (Lowest_Kperiod)
                 */
                
                let param1 = (security.value - lowestOfLows)
                let param2 = (highestOfHighs - lowestOfLows)
                
                let percentK: Double = abs(param1/param2)
                percentKs.append(percentK)
                dates.append(security.date)
            }
            
            var percentDs: [Double] = []
            let percentKsCount: Int = percentKs.count
            for index in 0..<percentKsCount {
                
                /*
                 
                 3 day SMA of %K
                 
                          (K1 + K2 + K3)
                  %D  =     -----------
                                 (3)
                 */
                
                let next3 = percentKs.suffix(percentKsCount - index).prefix(3)
                let sumOf3 = next3.reduce(0, +)
                let percentD = sumOf3/3.asDouble
                percentDs.append(percentD)
            }
            
            return .init(dates: dates,
                         percentKs: percentKs,
                         percentDs: percentDs)
        }
        
        let values: Value
        public init(_ history: [Security]) {
            self.values = Stochastics.calculate(history)
        }
    }
}
