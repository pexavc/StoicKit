//
//  File.swift
//  
//
//  Created by PEXAVC on 4/13/21.
//

import Foundation
import Vapor

final class Node: Content {
    static let schema = "Node"
    
    let source: String
    let target: String
    let length: Int
    
    init(source: String, target: String, length: Int = 1) {
        self.source = source
        self.target = target
        self.length = length
    }
}

final class NodeError: Content {
    static let schema = "NodeError"
    
    let paths: [[NodePath]]
    let bestPaths: [[NodePath]]
    let bestError: Double
    let pathsBestError: [NodePath]
    
    init(paths: [[NodePath]]) {
        self.paths = paths
        self.bestPaths = paths.map { i in [ i.filter({ j in abs(j.error) == abs(i.sorted(by: { abs($0.error) < abs($1.error) }).first!.error) }).first! ] }
        let flattened = Array(paths.flatMap { $0 })
        let smallest = flattened.map {  abs($0.error) }.min() ?? 100000
        let actual = flattened.first(where: { $0.error == smallest })?.error ?? 0.0
        bestError = actual
        pathsBestError = flattened.filter({ $0.error == actual })
    }
}

final class NodePath: Content {
    static let schema = "NodePath"
    
    let nodes: [Node]
    let error: Double
    
    init(nodes: [Node], error: Double) {
        self.nodes = nodes
        self.error = error
    }
}

final class NodeMeta: Content {
    static let schema = "NodeMeta"
    
    let label: String
    let color: String
    
    init(label: String, color: String) {
        self.label = label
        self.color = color
    }
}
