import Foundation

extension Indicators {
    public struct Volatility {
        let paired: PairedSecurity
        
        var momentum: Double {
            paired.base.value > paired.previous.value ? 1 : -1
        }
        
        var volatility: Double {
            (paired.base.value - paired.previous.value) / 2
        }
        
        var change: Double {
            return (paired.base.value - paired.previous.value) / paired.previous.value
        }
        
        var volMomentum: Double {
            paired.base.volume > paired.previous.volume ? 1 : -1
        }
        
        var volumeVolatiliy: Double {
            (paired.base.volume - paired.previous.volume) / 2
        }
        
        var volumeChange: Double {
            (paired.base.volume - paired.previous.volume) / paired.previous.volume
        }
    }
}
