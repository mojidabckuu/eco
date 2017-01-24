//
//  Request.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/22/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

open class BaseModelRequest<Model: _Model> {
    
    var request: Alamofire.Request // request it self
    var model: Model? // object where to flush
    
    internal var response: DataResponse<Any>? // cached response
    
    public init(request: Alamofire.Request, model: Model? = nil) {
        self.request = request
        self.model = model
    }
    
    // Error catch
    func `catch`(_ completion: @escaping ((Error?) -> ())) -> Self {
        self.request.responseRaw { (request, response, data, error) in
            completion(error)
        }
        return self
    }
    
    // Base parsing
    @discardableResult
    func raw(_ completion: @escaping (URLRequest?, URLResponse?, Data?) -> ()) -> Self {
        self.request.responseRaw { (request, response, data, error) in
            completion(request, response, data)
        }
        return self
    }
    
    @discardableResult
    func jsonObject(_ completion: @escaping ([String: Any]?) -> ()) -> Self {
        cacheJSON { (response) in
            completion(response.result.value as? [String : Any])
        }
        return self
    }
    
    @discardableResult
    func rawModel(_ completion: @escaping ([String: Any]?) -> ()) -> Self {
        cacheJSON { (response) in
            let value = response.result.value as? [String: Any]
            let modelData = value?[Model.modelName] as? [String: Any]
            completion(modelData)
        }
        return self
    }
    
    fileprivate func cacheJSON(_ completion: @escaping ((DataResponse<Any>) -> (Void))) {
        guard let response = self.response else {
            self.request.JSON(completionHandler: { (response) in
                self.response = response
                completion(response)
            })
            return
        }
        completion(response)
    }
}

open class Request<Model: _Model>: BaseModelRequest<Model> {
    // Creates a new model
    func map(_ completion: @escaping ([Model]) -> ()) -> Self { fatalError("Not implemented") }
    func obtain(_ completion: @escaping (Model) -> ()) -> Self { fatalError("Not implemented") }
    // Updates curent model
    func flush(_ completion: @escaping (Model) -> ()) -> Self { fatalError("Not implemented") }
}

open class ProviderRequest<P: Provider, Model: _Model, R: Alamofire.Request>: Request<Model> where Model == P.Target {
    var provider: P
    var originalRequest: R
    
    init(provider: P, request: R, model: Model? = nil) {
        if "\(P.Target.self)" != "\(Model.self)" {
            fatalError("You are trying to pass different model and target")
        }
        self.provider = provider
        self.originalRequest = request
        super.init(request: request, model: model)
    }
    
    // Flush to existed object
    @discardableResult
    override func flush(_ completion: @escaping (Model) -> ()) -> Self {
        guard let model = self.model else { fatalError("You didn't pass any model to the request") }
        _flush(object: model, completion)
        return self
    }
    
    // Extract list of items
    @discardableResult
    override func map(_ completion: @escaping ([Model]) -> ()) -> Self {
        cacheJSON { (response) in
            
            guard let value = response.result.value as? [String: Any] else {
                print("WARNING: Value is empty")
                return
            }
            guard let data = value[Model.modelsName] as? [[String: Any]] else {
                print("WARNING: Model value is empty")
                return
            }
            let models = data
                .map     { Map(mappingType: .fromJSON, JSON: $0) }
                .flatMap { P.mapping(target: nil, map: $0) }
            completion(Array(models))
        }
        return self
    }
    
    //Obtain single object
    @discardableResult
    override func obtain(_ completion: @escaping (Model) -> ()) -> Self {
        _flush(object: Model(), completion)
        return self
    }
    
    @discardableResult
    private func _flush(object: Model!, _ completion: @escaping (Model) -> ()) -> Self {
        cacheJSON { (response) in
            guard let value = response.result.value as? [String: Any] else {
                print("WARNING: Value is empty")
                return
            }
            guard let data = value[Model.modelName] as? [String: Any] else {
                print("WARNING: Model value is empty")
                return
            }
            let map = Map(mappingType: .fromJSON, JSON: data)
            let mappedModel = P.mapping(target: object, map: map)
            completion(mappedModel)
        }
        return self
    }
    
    @discardableResult
    func validate(_ validation: @escaping Alamofire.Request.ValidationD) {
        self.request.validate { (_, _, _) -> Alamofire.Request.ValidationResult in
            // TODO: Do we have provide Error in that case
            guard let value = self.response!.result.value as? [String: Any] else {
                print("WARNING: Value is empty")
                return .failure(NSError(domain: "com.request.validate", code: 0, userInfo: [:]))
            }
            guard let data = value[Model.modelName] as? [String: Any] else {
                print("WARNING: Model value is empty")
                return .failure(NSError(domain: "com.request.validate", code: 0, userInfo: [:]))
            }
            let map = Map(mappingType: .fromJSON, JSON: data)
            
            return .success
        }
    }
}

