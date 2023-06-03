//
//  File.swift
//  
//
//  Created by PEXAVC on 4/14/21.
//

import Foundation
import Vapor

final class Chart: Content {
    static let schema = "Chart"
    
    public var minX: Int
    public var maxX: Int
    public var labels: [String]
    public var data: [IndicatorPredictedResult]
    
    public init(minX: Int, maxX: Int, labels: [String], data: [IndicatorPredictedResult]) {
        self.minX = minX
        self.maxX = maxX
        self.labels = labels
        self.data = data
    }
}
