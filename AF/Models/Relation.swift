//
//  Relation.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/22/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import Foundation
import ObjectMapper

public typealias Record = Providable

public struct RelationConfiguration {
    struct Keys {
        static var offset = "offset"
        static var length = "count"
        static var total = "total_count"
    }
}

open class Relation<Model: Providable> {
    fileprivate var _items: [Model] = []
    
    var items: [Model] { return _items }
    var newItems: [Model] = []
    
    // TOOD: Probably add chunks to know that happened to the data, etc.
    
    var offset: Any? // offset starting from the last item
    var total: Int = 0 // total expected count
    var length: Int = 0 // last page received count
    
    var parameters: [String: Any] = [:]
    
    typealias IndexBlock = ([String: Any]) -> (Request<Model>)
    typealias CreateBlock = ([String: Any]) -> (Request<Model>)
    
    required public init() {}
    init(index: @escaping IndexBlock,
         create: CreateBlock? = nil) {
        self.indexBlock = index
        if let create = create { self.createBlock = create }
    }
    
    var indexBlock: (IndexBlock) = { parameters in
        return Model.remote.index(attributes: parameters)
    }
    var createBlock: (CreateBlock) = { parameters in
        return Model.remote.create(attributes: parameters)
    }
    
    func index() -> Request<Model> {
        return self.indexBlock(self.parameters)
    }
    func create(attributes: [String: Any]) -> Request<Model> {
        return self.createBlock(attributes)
    }
    // Reserved
    //    func deleteAll() -> PluralRequest<Model> { fatalError("Not implemented") }
    
    @discardableResult
    func `where`(_ parameters: [String: Any]) -> Self {
        self.parameters = parameters
        return self
    }
    
    func reset() {
        self.offset = nil
        self.total = 0
    }
}

extension Relation {
    public func update(attributes: [String: Any]) {
        let map = Map(mappingType: .fromJSON, JSON: attributes)
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        newItems <- map[Model.modelsName]
        newItems <- map["\(Model.modelsName).items"]
        offset <- map["\(Model.modelsName).\(RelationConfiguration.Keys.offset)"]
        total  <- map["\(Model.modelsName).\(RelationConfiguration.Keys.total)"]
        length <- map["\(Model.modelsName).\(RelationConfiguration.Keys.length)"]
    }
}

open class RelationOf<Model: Providable, Parent>: Relation<Model> {
    
    fileprivate var _parent: Parent?
    
    open var parent: Parent? { return _parent }
    
    required public init() {
        super.init()
    }
    
    init(with parent: Parent? = nil) {
        super.init()
        _parent = parent
    }
    
    init(parent: Parent?, index: @escaping IndexBlock, create: CreateBlock? = nil) {
        super.init(index: index, create: create)
        _parent = parent
    }
    
    override func create(attributes: [String : Any]) -> Request<Model> {
        var attr = attributes
        if let parent = self.parent {
            attr["parent"] = parent
        }
        return super.create(attributes: attr)
    }
}

extension Relation: MutableCollection, BidirectionalCollection {
    public var startIndex: Int { return _items.startIndex }
    public var endIndex: Int { return _items.endIndex }
    
    public subscript (position: Int) -> Model {
        get { return _items[position] }
        set { _items[position] = newValue }
    }
    
    public subscript (range: Range<Int>) -> ArraySlice<Model> {
        get { return _items[range] }
        set { _items.replaceSubrange(range, with: newValue) }
    }
    
    public func index(after i: Int) -> Int { return _items.index(after: i) }
    public func index(before i: Int) -> Int { return _items.index(before: i) }
}

extension Relation: RangeReplaceableCollection {
    public func append(_ newElement: Model){
        _items.append(newElement)
    }
    
    public func append<S : Sequence>(contentsOf newElements: S) where S.Iterator.Element == Model {
        _items.append(contentsOf: newElements)
    }
    
    public func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == Model {
        _items.replaceSubrange(subRange, with: newElements)
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        _items.removeAll(keepingCapacity: keepCapacity)
    }
}
