//
//  File.swift
//  
//
//  Created by PEXAVC on 4/12/21.
//

import Foundation
import Vapor

public struct Security: Codable {
    let value: Double
    let volume: Double
    let high: Double
    let low: Double
    let dateEpoch: Double
    let dateAsString: String
    
    var date: Date {
        dateEpoch.date()
    }
}

public struct Securities: Codable {
    let data: [Security]
}

final class SecurityResult: Content {
    static let schema = "SecurityResult"
    
    let result: [SecurityPredictionResult]
    let graph: SecurityNodeGraph
    let errors: NodeError
    let dataSizes: [Int]
    let daysPages: [[String: Int]]
    let chart: Chart
    
    init(result: [SecurityPredictionResult],
         graph: SecurityNodeGraph,
         errors: NodeError,
         dataSizes: [Int],
         daysPages: [[String: Int]],
         chart: Chart) {
        
        self.result = result
        self.graph = graph
        self.errors = errors
        self.dataSizes = dataSizes
        self.daysPages = daysPages
        self.chart = chart
    }
}

final class SecurityNodeGraph: Content {
    static let schema = "SecurityNodeGraph"
    
    let meta: [String: NodeMeta]
    let nodes: [[Node]]
    
    init(meta: [String: NodeMeta], nodes: [[Node]]) {
        self.meta = meta
        self.nodes = nodes
    }
}

final class SecurityPredictionResult: Content {
    static let schema = "SecurityPredictionResult"
    
    let predictions: [PredictionResult]
    let dataSize: Int
    
    init(predictions: [PredictionResult], dataSize: Int) {
        self.predictions = predictions
        self.dataSize = dataSize
    }
}

final class IndicatorResult: Content {
    static let schema = "IndicatorResult"
    
    let title: String
    let days: Int
    
    init(title: String, days: Int) {
        self.title = title
        self.days = days
    }
}

final class IndicatorPredictedResult: Content {
    static let schema = "IndicatorPredictedResult"
    
    let indicator: [IndicatorResult]
    let value: Double
    let id: String
    
    init(indicator: [IndicatorResult], value: Double, id: String = UUID().uuidString) {
        self.indicator = indicator
        self.value = value
        self.id = id
    }
}

final class PredictionResult: Content {
    static let schema = "PredictionResult"
    
//    let indicators: IndicatorPredictedResult
    let comparable: Security
    let date: Date
    let dateAsString: String
    let dataSize: Int
    let indicators: [IndicatorResult]
    let value: Double
    let predictionTime: Double
    
    init(comparable: Security,
         dataSize: Int,
         indicator1: Indicators.Variant,
         indicator2: Indicators.Variant,
         days1: Int,
         days2: Int,
         value: Double,
         time: Double) {
        
        self.indicators = [ IndicatorResult.init(title: "\(indicator1)", days: days1), IndicatorResult.init(title: "\(indicator2)", days: days2) ]
        self.value = value
        self.date = comparable.date
        self.dateAsString = comparable.dateAsString
        self.dataSize = dataSize
        self.predictionTime = time
        self.comparable = comparable
    }
}
