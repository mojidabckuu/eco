//
//  Comment.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/23/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import Foundation
import ObjectMapper

protocol Commentable {
    var id: Int! { get set }
}

final class Comment: Providable {
    var id: Int!
    var text: String!
    
    static let remote = RemoteProvider<Comment>.self
    
    lazy var local: LocalProvider<Comment> =    { return LocalProvider<Comment>(target: self) }()
    lazy var remote: RemoteProvider<Comment> =  { return CommentProvider(target: self) }()
}

class CommentProvider: RemoteProvider<Comment> {
    
    override class func mapping(target: Comment!, map: Map) -> Comment {
        target.text <- map["text"]
        return target
    }
    
    override func create() -> Request<Comment> {
        // JSON -> Request
        fatalError("gello")
    }
    
    override class func create(attributes: [String : Any]) -> Request<Comment> {
        let commentable = attributes["parent"] as? Commentable
        
        fatalError("Method is unavailable use `create(attributes:post)`")
    }
}
