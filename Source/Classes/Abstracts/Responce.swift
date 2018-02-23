//
//  Responce.swift
//  OpenAirSwift_iOS
//
//  Created by Vladimir Abramichev on 02/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public struct Responce {
    var responces: [CommandResponse]
    var status: Int?
}

public struct CommandResponse {
    var origine: Command
    var status: Int
    var content: [Decoder]?
}

extension CommandResponse {
    
    func get<T: Decodable>() throws -> T {
        return try get(index: 0)
    }
    
    func get<T: Decodable>(index: Int) throws -> T {
        guard
            let decoders = self.content
        else {
            throw OpenAirError.noContent
        }
        
        return try T.init(from: decoders[index])
    }
    
    func getCollection<T: Decodable>() throws -> [T] {
        guard
            let decoders = self.content
            else {
                throw OpenAirError.noContent
        }
        
        var collection = [T]()
        for decoder in decoders {
            let item = try T.init(from: decoder)
            collection.append(item)
        }
        
        return collection
    }
}
