//
//  Post.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/23/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class Post: Model, Providable, Commentable {
    var id: Int!
    var createAt: Date!
    var text: String!
    lazy var comments: RelationOf<Comment, Post> = { return RelationOf(with: self) }()
    
    public required init() {}
    
    public static var remote: RemoteProvider<Post>.Type { return PostProvider.self }
    lazy var remote: RemoteProvider<Post> = { return PostProvider(target: self) }()
}

protocol CommetableProvider {
    associatedtype Target: Record
    func comment(attributes: [String: Any]) -> Request<Comment>
}

// API
class PostProvider: RemoteProvider<Post>, CommetableProvider {
    // Mapping
    @discardableResult
    override static func mapping(target: Target! = Target(), map: Map) -> Target {
        target.text <- map["text"]
        return target
    }
    
    //Actions
    override func create() -> Request<Target> {
        let parameters: [String: Any] = [:]
        return self.request(SessionManager.default.request("", method: .post, parameters: parameters))
    }
    
    func comment(attributes: [String: Any]) -> Request<Comment> {
        return CommentProvider.create(attributes: attributes)
    }
}
