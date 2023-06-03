//
//  File.swift
//  
//
//  Created by PEXAVC on 11/26/21.
//

import Foundation
import Fluent
import Vapor
import Core
import Storage
import Datastore

struct MarqueController: RouteCollection {
    let loopGroup: EventLoopGroup
    
    init(loopGroup: EventLoopGroup) {
        self.loopGroup = loopGroup
//        service.gcs = backend
    }
    
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("marque")
//        todos.get(use: index)
        
        todos.group("engrave") { todo in
            todo.on(.POST, body: .collect(maxSize: 800000), use: engrave)
        }
        
        todos.group("process") { todo in
            todo.on(.POST, body: .collect(maxSize: 800000), use: process)
        }
    }
    
    func engrave(req: Request) throws -> EventLoopFuture<EngravingResult> {
        let promise = loopGroup.next().makePromise(of: EngravingResult.self)
        let contentType = req.headers["Content-Type"]
        do {
            let encoder = StegoEncoder()
            let decoder = StegoDecoder()
            let status = try req.content.decode(Engraving.self)
            
            let array = status.photo.toArray(type: UInt32.self)
            
            let newArray = try encoder.hide(string: status.message, in: array, size: array.count)
            
            guard let _ = try decoder.search(in: newArray, size: newArray.count) else {
                throw StegoError.invalidImage
            }
            
            promise.completeWith(.init(catching: {
                EngravingResult.init(output: "success", data: newArray)
            }))
        } catch let error {
            print(error.localizedDescription)
            promise.completeWith(.init(catching: {
                EngravingResult.init(output: "fail")
            }))
        }
        
        return promise.futureResult
    }
    
    func process(req: Request) throws -> EventLoopFuture<ProcessResult> {
        let promise = loopGroup.next().makePromise(of: ProcessResult.self)
        let contentType = req.headers["Content-Type"]
        do {
            
            let decoder = StegoDecoder()
            let status = try req.content.decode(Process.self)
            
            let array = status.photo.toArray(type: UInt32.self)
            
            guard let string = try decoder.search(in: array, size: array.count) else {
                throw StegoError.invalidImage
            }
            
            guard String(string.prefix(DefaultsMarque.dataPrefix.count)) == DefaultsMarque.dataPrefix
              && String(string.suffix(DefaultsMarque.dataSuffix.count)) == DefaultsMarque.dataSuffix else {
                throw StegoError.invalidImage
            }
            
            let endIndex = string.index(string.endIndex, offsetBy: -DefaultsMarque.dataSuffix.count)
            let startIndex = string.index(string.startIndex, offsetBy: DefaultsMarque.dataPrefix.count)

            guard let data = Data(base64Encoded: String(string[startIndex..<endIndex])) else {
                throw StegoError.invalidImage
            }
            
            promise.completeWith(.init(catching: {
                ProcessResult.init(output: String.init(data: data, encoding: .utf8) ?? "fail")
            }))
        } catch let error {
            print(error.localizedDescription)
            promise.completeWith(.init(catching: {
                ProcessResult.init(output: "fail")
            }))
        }
        
        return promise.futureResult
    }
}
extension Data {
    func toArray<T>(type: T.Type) -> [T] where T: ExpressibleByIntegerLiteral {
        Array(unsafeUninitializedCapacity: self.count/MemoryLayout<T>.stride) { (buffer, i) in
            i = copyBytes(to: buffer) / MemoryLayout<T>.stride
        }
    }
}
