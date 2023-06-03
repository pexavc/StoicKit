//
//  DataSet.swift
//  AIToolbox
//
//  Created by Kevin Coble on 12/6/15.
//  Copyright © 2015 Kevin Coble. All rights reserved.
//

import Foundation


public enum DataSetType   //  data type
{
    case Regression
    case Classification
}

enum DataTypeError: Error {
    case InvalidDataType
    case DataWrongForType
    case WrongDimensionOnInput
    case WrongDimensionOnOutput
}

enum DataIndexError: Error {
    case Negative
    case IndexAboveDimension
    case IndexAboveDataSetSize
}


public class DataSet: Codable {
//    public static var supportsSecureCoding: Bool = true
    
    let dataType : DataSetType
    let inputDimension: Int
    let outputDimension: Int
    var inputs: [[Double]]
    var outputs: [[Double]]?
    var classes: [Int]?
    var optionalData: AnyObject?        //  Optional data that can be temporarily added by methods using the data
    var labels: [String] = []
    public init(dataType : DataSetType, inputDimension : Int, outputDimension : Int)
    {
        //  Remember the data parameters
        self.dataType = dataType
        self.inputDimension = inputDimension
        self.outputDimension = outputDimension
        
        //  Allocate data arrays
        inputs = []
        if (dataType == .Regression) {
            outputs = []
        }
        else {
            classes = []
        }
    }
    
    public init?(fromDataSet: DataSet, withEntries: [Int])
    {
        //  Remember the data parameters
        self.dataType = fromDataSet.dataType
        self.inputDimension = fromDataSet.inputDimension
        self.outputDimension = fromDataSet.outputDimension
        
        //  Allocate data arrays
        inputs = []
        if (dataType == .Regression) {
            outputs = []
        }
        else {
            classes = []
        }
        
        //  Copy the entries
        do {
            try includeEntries(fromDataSet: fromDataSet, withEntries: withEntries)
        }
        catch {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case inputDimension
        case outputDimension
        case inputs
        case outputs
        case labels
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let inDim: Int = try container.decode(Int.self, forKey: .inputDimension)
        let outDim: Int = try container.decode(Int.self, forKey: .outputDimension)
        let inputs: [[Double]] = try container.decode([[Double]].self, forKey: .inputs)
        let outputs: [[Double]] = try container.decode([[Double]].self, forKey: .outputs)
        let labels: [String] = try container.decode([String].self, forKey: .labels)

        self.init(
            dataType: .Regression,
            inputDimension: inDim,
            outputDimension: outDim)

        self.inputs = inputs
        self.outputs = outputs
        self.labels = labels
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(inputDimension, forKey: .inputDimension)
        try container.encode(outputDimension, forKey: .outputDimension)
        try container.encode(inputs, forKey: .inputs)
        try container.encode(outputs, forKey: .outputs)
        try container.encode(labels, forKey: .labels)
    }
    
    public func includeEntries(fromDataSet: DataSet, withEntries: [Int]) throws
    {
        //  Make sure the dataset matches
        if dataType != fromDataSet.dataType { throw DataTypeError.InvalidDataType }
        if inputDimension != fromDataSet.inputDimension { throw DataTypeError.WrongDimensionOnInput }
        if outputDimension != fromDataSet.outputDimension { throw DataTypeError.WrongDimensionOnOutput }
        
        //  Copy the entries
        for index in withEntries {
            if (index  < 0) { throw DataIndexError.Negative }
            if (index  >= fromDataSet.size) { throw DataIndexError.IndexAboveDataSetSize }
            inputs.append(fromDataSet.inputs[index])
            if (dataType == .Regression) {
                outputs!.append(fromDataSet.outputs![index])
            }
            else {
                classes!.append(fromDataSet.classes![index])
                if outputs != nil {
                    outputs!.append(fromDataSet.outputs![index])
                }
            }
        }
    }
    
    public var size: Int
    {
        return inputs.count
    }
    
    public func singleOutput(index: Int) -> Double?
    {
        //  Validate the index
        if (index < 0) { return nil}
        if (index >= inputs.count) { return nil }
        
        //  Get the data
        if (dataType == .Regression) {
            return outputs![index][0]
        }
        else {
            return Double(classes![index])
        }
    }
    
    public func addDataPoint(input : [Double], output: [Double], label: String = "unknown") throws
    {
        //  Validate the data
        if (dataType != .Regression) { throw DataTypeError.DataWrongForType }
        if (input.count != inputDimension) { throw DataTypeError.WrongDimensionOnInput }
        if (output.count != outputDimension) { throw DataTypeError.WrongDimensionOnOutput }
        
        //  Add the new data item
        inputs.append(input)
        outputs!.append(output)
        self.labels.append(label)
    }
    
    public func addDataPoint(input : [Double], output: Int) throws
    {
        //  Validate the data
        if (dataType != .Classification) { throw DataTypeError.DataWrongForType }
        if (input.count != inputDimension) { throw DataTypeError.WrongDimensionOnInput }
        
        //  Add the new data item
        inputs.append(input)
        classes!.append(output)
    }
    
    public func setClass(index: Int, newClass : Int) throws
    {
        //  Validate the data
        if (dataType != .Classification) { throw DataTypeError.DataWrongForType }
        if (index < 0) { throw  DataIndexError.Negative }
        if (index > inputs.count) { throw  DataIndexError.Negative }
        
        classes![index] = newClass
    }
    
    public func addTestDataPoint(input : [Double]) throws
    {
        //  Validate the data
        if (input.count != inputDimension) { throw DataTypeError.WrongDimensionOnInput }
        
        //  Add the new data item
        inputs.append(input)
    }
    
    public func getClass(index: Int) throws ->Int
    {
        //  Validate the data
        if (dataType != .Classification) { throw DataTypeError.DataWrongForType }
        if (index < 0) { throw  DataIndexError.Negative }
        if (index > inputs.count) { throw  DataIndexError.Negative }
        
        return classes![index]
    }
    
    public func getRandomIndexSet() -> [Int]
    {
        //  Get the ordered array of indices
        var shuffledArray: [Int] = []
        for i in 0..<inputs.count - 1 { shuffledArray.append(i) }
        
        // empty and single-element collections don't shuffle
        if size < 2 { return shuffledArray }
        
        //  Shuffle
        for i in 0..<inputs.count - 1 {
            let j = Int.random(in: 0..<inputs.count - i) + i//Int(arc4random_uniform(UInt32(inputs.count - i))) + i
            guard i != j else { continue }
            shuffledArray.swapAt(i, j)
        }
        
        return shuffledArray
    }
}
