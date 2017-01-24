//
//  Provider.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/23/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

public protocol _Provider {}

public protocol Provider: _Provider {
    associatedtype Target: _Model
    
    static func mapping(target: Target!, map: Map) -> Target
    static func validate(map: Map) -> Bool
    
    var target: Target { get }
    
    func create() -> Request<Target>
    func show() -> Request<Target>
    func patch(attributes: [String: Any]) -> Request<Target>
    func update(attributes: [String: Any]) -> Request<Target>
    func delete() -> Request<Target>
    
    static func index(attributes: [String: Any]) -> Request<Target>
    static func create(attributes: [String: Any]) -> Request<Target>
}

public class RemoteProvider<Model: Record>: Provider {
    public typealias Target = Model
    
    public var target: Target
    
    init(target: Target) {
        self.target = target
    }
    
    public class func build(attributes: [String: Any]) -> Target? {
        let target = Target()
        let map = Map(mappingType: .fromJSON, JSON: attributes)
        guard self.validate(map: map) else {
            return nil
        }
        return self.mapping(target: target, map: map)
    }
    
    public func create() -> Request<Target> { fatalError("Not implemented") }
    public func show() -> Request<Target> { fatalError("Not implemented") }
    public func patch(attributes: [String: Any]) -> Request<Target> { fatalError("Not implemented") }
    public func update(attributes: [String: Any]) -> Request<Target> { fatalError("Not implemented") }
    public func delete() -> Request<Target> { fatalError("Not implemented") }
    
    public class func index(attributes: [String: Any]) -> Request<Target> { fatalError("Not implemented") }
    public class func create(attributes: [String: Any]) -> Request<Target> { fatalError("Not implemented") }
    
    public class func mapping(target: Model!, map: Map) -> Model { fatalError("Not implemented") }
    public class func validate(map: Map) -> Bool { return true }
    
    func request(_ request: Alamofire.Request) -> Request<Target> {
        return ProviderRequest(provider: self, request: request, model: self.target)
    }
}

class LocalProvider<Model: Record>: Provider {
    typealias Target = Model
    
    var target: Target
    
    init(target: Target) {
        self.target = target
    }

    public func create() -> Request<Target> { fatalError("Not implemented") }
    public func show() -> Request<Target> { fatalError("Not implemented") }
    public func patch(attributes: [String: Any]) -> Request<Target> { fatalError("Not implemented") }
    public func update(attributes: [String: Any]) -> Request<Target> { fatalError("Not implemented") }
    public func delete() -> Request<Target> { fatalError("Not implemented") }
    
    public class func index(attributes: [String: Any]) -> Request<Target> { fatalError("Not implemented") }
    public class func create(attributes: [String: Any]) -> Request<Target> { fatalError("Not implemented") }

    public class func mapping(target: Model!, map: Map) -> Model { fatalError("Not implemented") }
    public class func validate(map: Map) -> Bool { return true }
    
    func update(_ attributes: [String: Any]? = nil) throws -> Bool { fatalError("Not implemented") }
    func update(_ attribute: String, value: Any) throws -> Bool { fatalError("Not implemented") }
    func destroy() throws { fatalError("Not implemented") }
//    public static func destroy(scope identifier: DatabaseRepresentable) throws {}
//    public static func destroy(_ records: [ActiveRecord]) throws {}
//    public static func destroy(_ record: ActiveRecord) throws {}
    func save() throws { fatalError("Not implemented") }
    func save(_ validate: Bool) throws { fatalError("Not implemented") }
    class func create(_ attributes: [String : Any],
                       block: ((Target) -> (Void))? = nil) throws -> Target { fatalError("Not implemented") }
    class func create() throws -> Target { fatalError("Not implemented") }
    class func find(_ identifier: Any) throws -> Target { fatalError("Not implemented") }
    class func first() -> Target? { fatalError("Not implemented") }
//    static func includes(_ records: ActiveRecord.Type...) -> ActiveRelation<Self> {}
    // TODO: where and all is index action with parameteres.
//    static func `where`(_ attributes: [String: Any]) -> ActiveRelation<Target> {}
//    static func all() throws -> [Target] {}
}

public protocol Providable: Model {}

public extension Providable {
    var remote: RemoteProvider<Self> { fatalError("Not implemented") }
    static var remote: RemoteProvider<Self>.Type { fatalError("Not implemented") }
}
