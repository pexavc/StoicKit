import Foundation

public struct Indicators {
    public static let trailingDays: Int = 120
    
    public struct PairedSecurity {
        var base: Security
        var previous: Security
        
        var volatility: Volatility {
            Volatility.init(paired: self)
        }
        
        var toString: String {
            "[\(base.dateAsString)] Base: \(base.value) // [\(previous.dateAsString)] Prev: \(previous.value)"
        }
        
        var change: Double {
            (base.value - previous.value) / previous.value
        }
    }
    
    public enum Context {
        case high
        case close
        case low
    }
    
    let security: Security
    let quote: [Security]
    let pairings: [PairedSecurity]
    let basePair: PairedSecurity
    let history: [Security]
    
    public init(with quote: [Security]) {
        let sorted: [Security] = quote.sortDesc
        guard let security = sorted.first else {
            fatalError("failed to get security")
        }
        self.security = security
        self.quote = sorted
        
        let securities: [Security] = sorted.filterBelow(security.date)
        
        self.history = Array(securities.prefix(Indicators.trailingDays))
        
        if securities.count > 1 {
            var pairings: [PairedSecurity] = []
            for i in 0..<securities.count-1 {
                let base = securities[i]
                let previous = securities[i+1]
                
                pairings.append(.init(base: base, previous: previous))
            }
            self.pairings = pairings
        } else {
            self.pairings = []
        }
        
        self.basePair = .init(base: sorted[0], previous: sorted[1])
    }
    
    public init(_ security: Security,
                quote: [Security]) {
        self.security = security
        self.quote = quote
        
        let securities: [Security] = quote.filterBelow(security.date)
        
        self.history = Array(securities.prefix(Indicators.trailingDays))
        
        if securities.count > 1 {
            var pairings: [PairedSecurity] = []
            for i in 0..<securities.count-1 {
                let base = securities[i]
                let previous = securities[i+1]
                
                pairings.append(.init(base: base, previous: previous))
            }
            self.pairings = pairings
        } else {
            self.pairings = []
        }
        
        self.basePair = .init(base: quote[0], previous: quote[1])
    }
}

extension Security {
    public func value(forContext context: Indicators.Context) -> Double {
        switch context {
        case .high:
            return self.high
        case .close:
            return self.value
        case .low:
            return self.low
        }
    }
}

extension Array where Element == Security {
    public func filterAbove(_ date: Date) -> [Security] {
        return self.filter({ date.compare($0.date) == .orderedAscending })
    }
    
    public func filterBelow(_ date: Date) -> [Security] {
        return self.filter({ date.compare($0.date) == .orderedDescending })
    }
    
    var sortAsc: [Security] {
        self.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
    }
    
    var sortDesc: [Security] {
        self.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
}
