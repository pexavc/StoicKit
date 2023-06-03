//
//  File.swift
//  
//
//  Created by PEXAVC on 4/12/21.
//

import Foundation
import Fluent
import Vapor
import Core
import Storage
import Datastore

struct ThinkController: RouteCollection {
    let loopGroup: EventLoopGroup
    
    init(loopGroup: EventLoopGroup) {
        self.loopGroup = loopGroup
//        service.gcs = backend
    }
    
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("think")
//        todos.get(use: index)
        
        todos.group("generate") { todo in
            todo.on(.POST, body: .collect(maxSize: 500000), use: think)
        }
    }
    
    func think(req: Request) throws -> EventLoopFuture<SecurityResult> {
        let promise = loopGroup.next().makePromise(of: SecurityResult.self)
        let contentType = req.headers["Content-Type"]
        if let body = req.body.string {
            do {
                if let data = body.data(using: .utf8) {
                    let securities = try JSONDecoder().decode(Securities.self, from: data)
                    
                    //let indicators = Indicators.init(with: securities.data)
                    //print(securities.data.count)
                    let result = ThinkController.compilePrediction(securities: securities.data)
                    
                    promise.completeWith(.init(catching: {
                        result
                    }))
                }
            } catch let error {
                print(error)
            }
        }
        
        return promise.futureResult
    }
    
    public static func compilePrediction(securities: [Security]) -> SecurityResult {
        let minDays: Int = Defaults.minDays
        let maxDays: Int = Defaults.indicatorMaxDays
        
        let indicators: [Indicators.Variant] = [
            .smawa,
            .emawa,
            .macd,
            .stochd,
            .volchange
        ]
        
        
        var result: [SecurityPredictionResult] = []
        var predictionsFlattened: [IndicatorPredictedResult] = []
        
        // 1. prediction for each iteration, for each combination of option indicators
        for _ in 0..<9 {
//            let range = minDays...maxDays
            let dataSize = Int.random(in: minDays...Defaults.trainingMaxDays)
            
            var predictions: [PredictionResult] = []
            
            var completed: [[Indicators.Variant]] = []
            for variant1 in indicators {
                
                for variant2 in indicators {
                    if (completed.contains(where: { $0 == [variant1, variant2] || $0 == [variant2, variant1] })) {
                        continue
                    }
                    completed.append([variant1, variant2])
                
                    let pred = generate(fromQuote: securities,
                                          dataSize: dataSize,
                                          indicatorDays: minDays...maxDays,
                                          indicator1: variant1,
                                          indicator2: variant2)
                        
                    predictions.append(pred)
                    
                    
                    let flattenID: String = UUID().uuidString
                    //add to flatten
                    let predTests: [IndicatorPredictedResult] = pred.indicators.map{ .init(indicator: [.init(title: "\($0.title)", days: $0.days)], value: pred.value, id: flattenID) }
                    
                    let predDefault: [IndicatorPredictedResult] = Defaults.indicators.map{ .init(indicator: [.init(title: "\($0)", days: dataSize)], value: pred.value, id: flattenID) }
                    
                    //defaults
                    predictionsFlattened.append(contentsOf: predTests+predDefault)
                    
                }
            
            }
            
            
            
            result.append(.init(predictions: predictions, dataSize: dataSize))
        }
        
        // 2. Paginate data into readable JSON for front-end ease in manipulation
        var errorPages: [[NodePath]] = []//each iteration, and paths with errors of each optional indicator path
        var nodePages: [[Node]] = []//The full list of node paths possible for diagram draws
        var daysPages: [[String: Int]] = []//The days used per indicator including defaults
        var dataSizes: [Int] = []//The size of the data (training days)
        for item in result {
            var nodes: [Node] = []
            var errors: [NodePath] = []
            var days: [String: Int] = [:]
            for subItem in item.predictions {
                var errorNodes: [Node] = []
                
                
                var lastError: Double = 0.0
                for indicator in subItem.indicators {
                    
                    let error = (subItem.value - subItem.comparable.value(forContext: .close)) / subItem.comparable.value(forContext: .close)
                    
                    let nodesDefault: [Node] = Defaults.indicators.map{ .init(source: "\($0)", target: indicator.title) }
                    
                    lastError = error
                    
                    nodes.append(contentsOf: nodesDefault)
                    errorNodes.append(contentsOf: nodesDefault)
                    
                    days[indicator.title] = indicator.days
                }
                
                Defaults.indicators.forEach { dItem in
                    days["\(dItem)"] = item.dataSize
                }
                
                errors.append(.init(nodes: errorNodes, error: lastError))
            }
            
            dataSizes.append(item.dataSize)
            daysPages.append(days)
            errorPages.append(errors)
            nodePages.append(nodes)
        }
        
        // 3. Metadata
        let colors: [String: NodeMeta] = [
            "\(Indicators.Variant.smawa)": .init(label: "SMA Weighted Avg.", color: "#EC6CFF"),
            "\(Indicators.Variant.emawa)": .init(label: "EMA Weighted Avg.", color: "#FFCD00"),
            "\(Indicators.Variant.macd)": .init(label: "MacD", color: "#6cb8ff"),
            "\(Indicators.Variant.stochd)": .init(label: "Stochastic D", color: "#ff896c"),
            "\(Indicators.Variant.volchange)": .init(label: "Volume Change", color: "#6eff55"),
            "\(Indicators.Variant.volatility)": .init(label: "Volatility Average", color: "#a19a8e"),
            "\(Indicators.Variant.momentum)": .init(label: "Momentum", color: "#a19a8e"),
            "\(Indicators.Variant.change)": .init(label: "Change", color: "#a19a8e"),
            "\(Indicators.Variant.vwa)": .init(label: "Volume Weighted Avg.", color: "#a19a8e")
        ]
        
        return .init(result: result,
                     graph: .init(meta: colors,
                                  nodes: nodePages),
                     errors: .init(paths: errorPages),
                     dataSizes: dataSizes,
                     daysPages: daysPages,
                     chart: .init(minX: Defaults.minDays, maxX: Defaults.indicatorMaxDays, labels: Array(colors.keys), data: predictionsFlattened))
    }
    
    
    public static func generate(fromQuote quoteToUse: [Security],
                                dataSize: Int = 30,
                                indicatorDays: ClosedRange<Int>,
                                indicator1: Indicators.Variant,
                                indicator2: Indicators.Variant) -> PredictionResult {
        let securities = quoteToUse.sortAsc
        
        let time = Date().timeIntervalSinceNow
        //Securities part of window of days
        
        print("generating tonal model w/o sentiment: \(securities.count) securities discovered")
        
        let dataForDavid: DataSet = DataSet(
            dataType: .Regression,
            inputDimension: 6,
            outputDimension: 1)
        
        let days1 = Int.random(in: indicatorDays)
        let days2 = Int.random(in: indicatorDays)
        
        for index in 0..<dataSize {
            do {
                //we add a +1 to days, because we are going to predict from the
                //latest received stock. So we train the model upto the target date
                //
                //in this case the "target date/security" is the latest stock in
                //the quote received in the post request
                let trainable = securities.prefix(upTo: securities.count - (dataSize - index))
                let dataSet = SecurityDataSet(quote: Array(trainable),
                                              context: .close)
                
                let dataInput = dataSet.asArrayIMBHS(indicator1, indicator2, days1: days1, days2: days2, daysO: dataSize)
                
//                print(dataSet.indicators.macDAverage(days1, context: .close))
//                print(dataInput)
                try dataForDavid.addDataPoint(
                    input: dataInput,
                    output: dataSet.output,
                    label: trainable.last?.dateAsString ?? "\(index)")
                
            }
            catch {
                print("invalid dataSet")
            }
        }
        print("training")
        let david = SVMModel(
            problemType: .ϵSVMRegression,
            kernelSettings:
            KernelParameters(type: .Polynomial,
                             degree: 3,
                             gamma: 0.3,
                             coef0: 0.0))

        david.Cost = 1e3
        david.train(data: dataForDavid)
        
        print("tonal model generation - complete - ✅ - \(Date().timeIntervalSinceNow - time)")
        
        let quoteSorted = quoteToUse.sortDesc
        
        guard let comparable = quoteSorted.first else {
            fatalError("failed to get quoteSorted first element")
        }
        
        let prediction = predict(model: david,
                                 fromQuote: quoteSorted,
                                 indicator1: indicator1,
                                 indicator2: indicator2,
                                 days1,
                                 days2,
                                 dataSize)
//        print(prediction)
        return .init(comparable: comparable,
                     dataSize: dataSize,
                     indicator1: indicator1,
                     indicator2: indicator2,
                     days1: days1,
                     days2: days2,
                     value: prediction,
                     time: Date().timeIntervalSinceNow - time)
    }
    
    public static func predict(model: SVMModel,
                               fromQuote quote: [Security],
                               indicator1: Indicators.Variant,
                               indicator2: Indicators.Variant,
                               _ days1: Int,
                               _ days2: Int,
                               _ daysO: Int) -> Double {
        
        
        let securities = Array(quote.suffix(from: 1))
        
        let dataForDavid: DataSet = DataSet(
            dataType: .Regression,
            inputDimension: 6,
            outputDimension: 1)
        
        
        do {
            let dataSet = SecurityDataSet(quote: securities,
                                          context: .close)
            
            try dataForDavid.addDataPoint(
                input: dataSet.asArrayIMBHS(indicator1, indicator2, days1: days1, days2: days2, daysO: daysO),
                output: dataSet.output,
                label: securities.last?.dateAsString ?? "\(index)")
            
        }
        catch {
            print("invalid dataSet")
        }
        
        model.predictValues(data: dataForDavid)
        guard let output = dataForDavid.singleOutput(index: 0) else {
            print("prediction failed")
            return 0.0
        }
        
        return output
        
        print("prediction: \(output)")
    }
}
