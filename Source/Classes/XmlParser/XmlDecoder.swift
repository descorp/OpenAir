//
//  XmlDecoder.swift
//  Onboarding
//
//  Created by Vladimir Abramichev on 09/02/2018.
//  Copyright © 2018 Mobiquity. All rights reserved.
//

import Foundation
import SwiftyXMLParser

private struct XmlKey: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

struct XmlDecoder: Decoder {
    let xmlNode: XML.Element
    
    init(node: XML.Element) {
        self.xmlNode = node
        self.codingPath = node.childElements.flatMap { XmlKey(stringValue: $0.name) }
    }
    
    // Decoder
    let codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any] { return [:] }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        // Asked for a keyed type: top level required
        
        var dictionary = [String: XML.Element]()
        xmlNode.childElements.forEach { dictionary[$0.name] = $0 }
        return KeyedDecodingContainer(XmlKeyedDecodingContainer<Key>(xmlNodes: dictionary))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.typeMismatch(
            UnkeyedDecodingContainer.self,
            DecodingError.Context(codingPath: codingPath, debugDescription: "unkeyed decoding is not supported"))
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        // Asked for a value type: column name required
        guard let codingKey = codingPath.last else {
            throw DecodingError.typeMismatch(
                XmlDecoder.self,
                DecodingError.Context(codingPath: codingPath, debugDescription: "single value decoding requires a coding key"))
        }
        return XmlSingleValueDecodingContainer(xmlNode: xmlNode, column: codingKey)
    }
}

private struct XmlKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let xmlNodes:  [String: XML.Element]
    
    /// The path of coding keys taken to get to this point in decoding.
    /// A `nil` value indicates an unkeyed container.
    var codingPath: [CodingKey] { return [] }
    
    /// All the keys the `Decoder` has for this container.
    ///
    /// Different keyed containers from the same `Decoder` may return different keys here; it is possible to encode with multiple key types which are not convertible to one another. This should report all keys present which are convertible to the requested type.
    var allKeys: [Key] {
        return  xmlNodes.keys.flatMap { Key(stringValue: $0) }
    }
    
    /// Returns whether the `Decoder` contains a value associated with the given key.
    ///
    /// The value associated with the given key may be a null value as appropriate for the data format.
    ///
    /// - parameter key: The key to search for.
    /// - returns: Whether the `Decoder` has an entry for the given key.
    func contains(_ key: Key) -> Bool {
        return xmlNodes[key.stringValue] != nil
    }
    
    /// Decodes a null value for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: Whether the encountered value was null.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    func decodeNil(forKey key: Key) throws -> Bool {
        guard
            let node = xmlNodes[key.stringValue]
            else {
                throw DecodingError.keyNotFound(
                    key, DecodingError.Context(codingPath: [key],
                                               debugDescription: "Field \(key.stringValue) not found"))
        }
        
        return node.text == nil && node.childElements.isEmpty
    }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool { return try xmlNodes[key.stringValue]!.get() }
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double { return try xmlNodes[key.stringValue].get() }
    func decode(_ type: String.Type, forKey key: Key) throws -> String { return try xmlNodes[key.stringValue].get() }
    
    /// Decodes a value of the given type for the given key.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        guard
            let subNode = xmlNodes[key.stringValue]
        else {
            throw DecodingError.keyNotFound(
                key, DecodingError.Context(codingPath: [key],
                                           debugDescription: "Field \(key.stringValue) not found"))
        }
        
        guard
            subNode.childElements.count == 1,
            let dataElement = subNode.childElements.first
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [key],
                                                                    debugDescription: "Failed to decode \(key.stringValue)"))
        }
        
        return try T(from: XmlDecoder(node: dataElement))
    }
    
    /// Returns the data stored for the given key as represented in a container keyed by the given key type.
    ///
    /// - parameter type: The key type to use for the container.
    /// - parameter key: The key that the nested container is associated with.
    /// - returns: A keyed decoding container view into `self`.
    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is not a keyed container.
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("Not implemented")
    }
    
    /// Returns the data stored for the given key as represented in an unkeyed container.
    ///
    /// - parameter key: The key that the nested container is associated with.
    /// - returns: An unkeyed decoding container view into `self`.
    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is not an unkeyed container.
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError("Not implemented")
    }
    
    /// Returns a `Decoder` instance for decoding `super` from the container associated with the default `super` key.
    ///
    /// Equivalent to calling `superDecoder(forKey:)` with `Key(stringValue: "super", intValue: 0)`.
    ///
    /// - returns: A new `Decoder` to pass to `super.init(from:)`.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the default `super` key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the default `super` key.
    public func superDecoder() throws -> Decoder {
        fatalError("Not implemented")
    }
    
    /// Returns a `Decoder` instance for decoding `super` from the container associated with the given key.
    ///
    /// - parameter key: The key to decode `super` for.
    /// - returns: A new `Decoder` to pass to `super.init(from:)`.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for the given key.
    public func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError("Not implemented")
    }
}

private struct XmlSingleValueDecodingContainer: SingleValueDecodingContainer {
    let xmlNode: XML.Element
    let column: CodingKey
    
    var codingPath: [CodingKey] { return [] }
    
    /// Decodes a null value.
    ///
    /// - returns: Whether the encountered value was null.
    func decodeNil() -> Bool {
        return xmlNode.childElements.first { $0.name == column.stringValue} != nil
    }
    
    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value is null.
    func decode(_ type: Bool.Type)      throws -> Bool      { return try xmlNode.get() }
    func decode(_ type: Int.Type)       throws -> Int       { return try xmlNode.get() }
    func decode(_ type: Int8.Type)      throws -> Int8      { return try xmlNode.get() }
    func decode(_ type: Int16.Type)     throws -> Int16     { return try xmlNode.get() }
    func decode(_ type: Int32.Type)     throws -> Int32     { return try xmlNode.get() }
    func decode(_ type: Int64.Type)     throws -> Int64     { return try xmlNode.get() }
    func decode(_ type: UInt.Type)      throws -> UInt      { return try xmlNode.get() }
    func decode(_ type: UInt8.Type)     throws -> UInt8     { return try xmlNode.get() }
    func decode(_ type: UInt16.Type)    throws -> UInt16    { return try xmlNode.get() }
    func decode(_ type: UInt32.Type)    throws -> UInt32    { return try xmlNode.get() }
    func decode(_ type: UInt64.Type)    throws -> UInt64    { return try xmlNode.get() }
    func decode(_ type: Float.Type)     throws -> Float     { return try xmlNode.get() }
    func decode(_ type: Double.Type)    throws -> Double    { return try xmlNode.get() }
    func decode(_ type: String.Type)    throws -> String    { return try xmlNode.get() }
    
    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value is null.
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try T(from: XmlDecoder(node: xmlNode))
    }
}

extension Optional where Wrapped == XML.Element {
    public func get<T: LosslessStringConvertible>() throws -> T {
        guard
            let strongSelf = unwrap(self) as? XML.Element
        else {
            throw DecodingError.keyNotFound(XmlKey(stringValue: #function )!,
                                            DecodingError.Context(codingPath: [], debugDescription: "Not convertable to \(T.self)"))
        }
        
        let result: T = try strongSelf.get()
        return result
    }
}

extension XML.Element {
    public func get<T: LosslessStringConvertible>() throws -> T {
        guard
            let rawValue = self.text,
            let value = T(rawValue)
        else {
            throw DecodingError.typeMismatch(
                XmlDecoder.self,
                DecodingError.Context(codingPath: [], debugDescription: "Not convertable to \(T.self)"))
        }
        
        return value
    }
}
