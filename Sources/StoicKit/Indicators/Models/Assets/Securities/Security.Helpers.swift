//
//  Security.Helpers.swift
//  * stoic
//
//  Created by PEXAVC on 1/5/21.
//

import Foundation

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
    
    var dailies: [Security] {
        let ordered: [Security] = self.sortDesc
        var datesAdded = Set<Date>()
        var added: [Security] = []
        for elem in ordered {
            if !datesAdded.contains(elem.date.simple) &&
                elem.date.timeComponents().hour >= elem.date.openingHour  {
                datesAdded.insert(elem.date.simple)
                added.append(elem)
            }
        }
        return added
    }
}

extension Array where Element == Stock {
    public func filterAbove(_ date: Date) -> [Stock] {
        return self.filter({ date.compare($0.date) == .orderedAscending })
    }
    
    public func filterBelow(_ date: Date) -> [Stock] {
        return self.filter({ date.compare($0.date) == .orderedDescending })
    }
    
    var sortAsc: [Security] {
        self.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
    }
    
    var sortDesc: [Security] {
        self.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    var dailies: [Security] {
        let ordered: [Security] = self.sortDesc
        var datesAdded = Set<Date>()
        var added: [Security] = []
        for elem in ordered {
            if !datesAdded.contains(elem.date.simple) &&
                elem.date.timeComponents().hour >= elem.date.openingHour  {
                datesAdded.insert(elem.date.simple)
                added.append(elem)
            }
        }
        return added
    }
}
