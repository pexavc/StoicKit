//
//  TonalService.Indicators.Stochastics.swift
//  * stoic
//
//  Created by PEXAVC on 1/12/21.
//

import Foundation

extension StoicKit.Indicators {
    public func macD(context: Context) -> Double {
        let ema12 = ema(12, context: context)
        let ema26 = ema(26, context: context)
        
//        print("{TEST} \(self.security.date) - ema12: \(ema12) // ema26: \(ema26)")
        return ema12 - ema26
    }
    
    public func macDPrevious(context: Context) -> Double {
        MacD.init([security] + history, context: context).values.macDs.first ?? 0.0
    }
    
    public func macDSignal(context: Context) -> Double {
        MacD.init([security] + history, context: context).values.macDSignals.first ?? 0.0
    }
    
    public func macDPreviousSignal(context: Context) -> Double {
        MacD.init(history, context: context).values.macDSignals.first ?? 0.0
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
                                     context: Context,
                                     signal: Int = 9) -> MacD.Value {
            var securities = history
            print("%%%%%%%%%%%%%%%%%%%%%%%%")
            var dates: [Date] = []
            var macDs: [Double] = []
            for _ in 0..<securities.count {
                
                let security = securities.removeFirst()
                let indicatorsOfThePast = StoicKit.Indicators.init(security, with: history)
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
                let meanOfPeriod = sumOfPeriod/Double(signal)
                
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
        public init(_ history: [Security], context: Context) {
            self.values = MacD.calculate(history, context: context)
        }
    }
}
