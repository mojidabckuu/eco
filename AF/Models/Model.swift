//
//  Model.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/22/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol _LocalModel {
    // Local update to refresh the model
//    func update(with attributes: [String: Any])
}

public extension Mappable {
//    init?(attributes: [String: Any]) {
//        let map = Map(mappingType: .fromJSON, JSON: attributes)
//        self.init(map: map)
//    }
}

public protocol Initiable {
    init()
}

public protocol _Model: _LocalModel, Initiable {
    static var modelName: String { get }
    static var modelsName: String { get }
}

public extension _Model {
    static var modelName: String { return "" }
    static var modelsName: String { return "" }
//    func update(with attributes: [String: Any]) {
//        let map = Map(mappingType: .fromJSON, JSON: attributes)
//        var welf = self
//        welf.mapping(map: map)
//    }
}

public protocol MedianModel: _Model {}

public protocol Model: MedianModel {
//    associatedtype Mini: _Model
//    typealias Mini = Self
//    func create() -> Request<Mini>
//    func show() -> Request<Mini>
//    func patch(attributes: [String: Any]) -> Request<Mini>
//    func update(attributes: [String: Any]) -> Request<Mini>
//    func delete() -> Request<Mini>
//    static func index(parameters: [String: Any]) -> Request<Mini>
//    static func create(parameters: [String: Any]) -> Request<Mini>
}

public extension Model {
//    func create() -> Request<Self> { fatalError("Not implemented") }
//    func show() -> Request<Self> { fatalError("Not implemented") }
//    func patch(attributes: [String: Any]) -> Request<Self> { fatalError("Not implemented") }
//    func update(attributes: [String: Any]) -> Request<Self> { fatalError("Not implemented") }
//    func delete() -> Request<Self> { fatalError("Not implemented") }
//    static func index(parameters: [String: Any]) -> Request<Self> { fatalError("Not implemented") }
//    static func create(parameters: [String: Any]) -> Request<Self> { fatalError("Not implemented") }
}
