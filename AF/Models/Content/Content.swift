//
//  Content.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/22/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import UIKit

protocol _Content {
    
    associatedtype M
    associatedtype V
    associatedtype C
    
    var items: [M] { get }
    
    func refresh()
    func loadMore()
    func loadItems()
    
    func fetch(items: [M])
}

public class Content<Model: Equatable, View: ViewDelegate, Cell: ContentCell>: _Content, ActionRaiser where View: UIView, Model: Record {

    typealias M = Model
    typealias V = View
    typealias C = Cell

    var relation: Relation<Model>
    
    open var items: [Model] {
        get { return relation.items }
        set {
            relation.removeAll()
            relation.append(contentsOf: newValue)
            self.reloadData()
        }
    }
    
    var configuration = Configuration.default
    
    open var view: View { return _view }
    private var _view: View
    open var delegate: BaseDelegate<Model, View, Cell>?
    
    let actions = ContentActionsCallbacks<Model, View, Cell>()
    let URLCallbacks = ContentURLCallbacks<Model, View, Cell>()
    var callbacks = ContentCallbacks<Model, View, Cell>()
    var scrollCallbacks = ScrollCallbacks<Model, View, Cell>()
    var viewDelegateCallbacks = ViewDelegateCallbacks<Model, View, Cell>()
    
    var offset: Any?
    var length: Int { return self.configuration.length }
    var totalCount: Int = 0
    
    public init(relation: Relation<Model>? = nil, view: View, delegate: BaseDelegate<Model, View, Cell>? = nil, configuration: Configuration? = nil) {
        if let relation = relation {
            self.relation = relation
        } else {
            self.relation = Relation()
        }
        
        if let configuration = configuration {
            self.configuration = configuration
        }
        _view = view
        _view.contentDelegate = delegate
        _view.contentDataSource = delegate
        self.delegate = delegate
        self.setupDelegate()
        self.setupControls()
    }
    
    func setupDelegate() {
        if self.delegate == nil {
            if view is UITableView {
                self.delegate = TableDelegate<Model, View, Cell>(content: self)
                _view.contentDelegate = self.delegate
                _view.contentDataSource = self.delegate
            } else if view is UICollectionView {
                self.delegate = CollectionDelegate<Model, View, Cell>(content: self)
                _view.contentDelegate = self.delegate
                _view.contentDataSource = self.delegate
            }
        } else {
            self.delegate?.content = self
        }
    }
    
    func setupControls() {
        if let refreshControl = self.configuration.refreshControl {
            refreshControl.addTarget(self, action: #selector(Content.refresh), for: .valueChanged)
            self.view.addSubview(refreshControl)
        }
        if let infiniteControl = self.configuration.infiniteControl {
            infiniteControl.addTarget(self, action: #selector(Content.loadMore), for: .valueChanged)
            self.view.addSubview(infiniteControl)
        }
    }
    
    // URL lifecycle
    fileprivate var _state: State = .none
    open var state: State { return _state }
    open var isAllLoaded: Bool { return _state == .allLoaded }
    
    open func reloadData() {
        self.delegate?.reload()
    }
    
    open dynamic func refresh() {
        if _state != .refreshing {
            _state = .refreshing
            configuration.infiniteControl?.isEnabled = true
            if !(configuration.refreshControl?.isAnimating == true) {
                self.configuration.infiniteControl?.startAnimating()
            }
            self.relation.reset()
            self.loadItems()
        }
    }
    open dynamic func loadMore() {
        if _state != .loading && _state != .refreshing && _state != .allLoaded {
            _state = .loading
            self.loadItems()
        }
    }
    open func loadItems() {
        if let load = self.URLCallbacks.onLoad {
            load(self)
        } else {
            let welf = self
            self.relation.index().jsonObject { (object) in
                if let object = object {
                    welf.relation.update(attributes: object)
                    welf.fetch(items: welf.relation.newItems)
                }
                if welf.relation.isEmpty || object == nil {
                    // TODO: Show no items
                }
            }
        }
    }
    
    // Utils
    
    func fetch(items: [Model]) {
        if self.state == .refreshing {
            self.relation.removeAll()
            if self.configuration.animatedRefresh {
                self.reloadData()
                self.add(items: items, index: 0)
            } else {
                self.relation.append(contentsOf: items)
                self.reloadData()
            }
            configuration.refreshControl?.stopAnimating()
        } else {
            self.add(items: items, index: self.relation.items.count)
        }
        configuration.infiniteControl?.stopAnimating()
        self.URLCallbacks.didLoad?(nil, items)
        if items.count < self.length {
            _state = .allLoaded
            configuration.infiniteControl?.isEnabled = false
        } else {
            _state = .none
        }
    }
    
    
    func error(error: Error?) {
        if let error = error {
            _state = .none
            self.URLCallbacks.didLoad?(error, [])
            return
        }
    }
    
    // Management
    
    func add(items items: [Model], index: Int = 0) {
        self.relation.insert(contentsOf: items, at: index)
        self.delegate?.insert(items, index: index)
    }
    func add(_ items: Model..., index: Int = 0) {
        self.add(items: items, index: index)
    }
    func delete(_ models: Model...) {
        self.delegate?.delete(models)
    }
    func reload(_ models: Model...) {
        self.delegate?.reload(models)
    }
}

//
//final class ContentOf<Model: _Model, Parent, View, Cell>: _Content {
//    typealias M = Model
//    typealias V = View
//    typealias C = Cell
//    
//    var relation: RelationOf<Model, Parent>!
//    var items: [Model] { return relation.items }
//    
//    var onLoad: ((ContentOf<Model, Parent, View, Cell>) -> ())?
//    
//    func refresh() {
//        self.relation.reset()
//        self.loadItems()
//    }
//    
//    func loadMore() {
//        
//    }
//    
//    func loadItems() {
//        if let load = self.onLoad {
//            load(self)
//        } else {
//            self.relation.index().extractRelation({ (items, offset, total) in
//                self.fetch(items: items)
//            }).catch { error in
//                
//            }
//        }
//    }
//    
//    func fetch(items: [Model]) {}
//    
//    init(relation: RelationOf<Model, Parent>, view: View, cell: Cell) {
//        self.relation = relation
//    }
//}

fileprivate extension Request {
    func extractRelation<TargetModel: _Model>(_ completion: @escaping ([TargetModel], Any?, Int) -> ()) -> Self {
        self.request.JSON { (response) in
            var models: [TargetModel] = []
            var offset: Any? = nil
            var total: Int = 0
            if let value = response.result.value as? [String: Any] {
                if let modelsData = value[TargetModel.modelsName] as? [[String: Any]] {
                    models = modelsData.flatMap({ (modelData) -> TargetModel? in
                        let model = TargetModel()
//                        model?.update(with: modelData)
                        return model
                    })
                } else {
                    print("Cannot extract model data")
                }
                offset = value["offset"]
                total = (value["total_count"] as? Int) ?? total
            }
            completion(models, offset, total)
        }
        return self
    }
}
