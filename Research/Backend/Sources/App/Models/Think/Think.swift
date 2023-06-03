//
//  File.swift
//  
//
//  Created by PEXAVC on 4/13/21.
//

import Foundation

public struct Defaults {
    public static let indicators: [Indicators.Variant] = [.volatility, .momentum, .change, .vwa]
    
    public static let minDays: Int = 4
    public static let trainingMaxDays: Int = 16
    public static let indicatorMaxDays: Int = 28
}
