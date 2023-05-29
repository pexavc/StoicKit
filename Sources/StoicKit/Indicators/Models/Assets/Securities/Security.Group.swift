//
//  Security.Group.swift
//  * stoic
//
//  Created by PEXAVC on 1/13/21.
//

import Foundation

public class SecurityGroup {
    public var stocks: [Security] = []
    public var crypto: [Security] = []
    
    public func get(_ type: SecurityType) -> [Security] {
        switch type {
        case .crypto:
            return crypto as? [CryptoCurrency] ?? []
        case .stock:
            return stocks as? [Stock] ?? []
        default:
            return []
        }
    }
}
