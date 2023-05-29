//
//  Asset.swift
//  * stoic (iOS)
//
//  Created by PEXAVC on 12/21/20.
//

import Foundation
import SwiftUI

public enum AssetType {
    case security
    case model
    case sentiment
    case user
}

public protocol Asset {
    var assetType: AssetType { get }
    var assetID: String { get }
    
    var symbol: String { get }
    var symbolImage: Image? { get }
    
    var symbolColor: Color { get }
    
    var title: String { get }
    var subtitle: String { get }
    var showDescription1: Bool { get }
    var description1: String { get }
    var description1_sub: String { get }
    var description2Title: String? { get }
    var showDescription2: Bool { get }
    var description2: String { get }
    
    var metadata1: String { get }
    var metadata2: String { get }
    
    var inValid: Bool { get }
    var isIncomplete: Bool { get }
    var canStore: Bool { get }
}

extension Asset {
}

extension Asset {
    public var symbolImage: Image? {
        nil
    }
    
    var asSecurity: Security? {
        return (self as? Security)
    }
    
    public var showDescription1: Bool {
        true
    }
    
    public var showDescription2: Bool {
        true
    }
    
    public var description2Title: String? {
        nil
    }
    
    public var isIncomplete: Bool {
        false
    }
    
    public var inValid: Bool { false }
    
    public var metadata1: String {
        ""
    }
    
    public var metadata2: String {
        ""
    }
    
    public var canStore: Bool {
        true
    }
}

extension Security {
    public var title: String {
        self.ticker.uppercased()
    }
    
    public var subtitle: String {
        self.isIncomplete ? metadata1 : "volume: "+self.volumeValue.abbreviate
    }
    
    public var symbol: String {
        self.indicator
    }
    
    public var symbolColor: Color {
        if self.isLatest {
            switch securityType {
            case .crypto:
                return .orange
            default:
                return .primary
            }
        } else {
            return .gray
        }
    }
    
    public var description1: String {
        self.isIncomplete ? metadata2 : "$\(self.lastValue.display)"
    }
    
    public var description1_sub: String {
        "\(self.isGainer ? "+" : "-")$\(self.changeAbsoluteValue.display.replacingOccurrences(of: "-", with: ""))"
    }
    
    public var description2: String {
        "\(self.isGainer ? "+" : "")\(self.changePercentValue.percent)%"
    }
    
    public var inValid: Bool { !self.isLatest }
    
    public var isIncomplete: Bool {
        self.lastValue == .zero && self.volumeValue == .zero
    }
}
