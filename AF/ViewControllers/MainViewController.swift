//
//  MainViewController.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/23/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class Root: Equatable {
    static func == (lhs: Root, rhs: Root) -> Bool {
        return false
    }
}

class User: Record, Equatable {
    var id: String!
    var email: String!
    
    public required init() {}
    
    static var remote: RemoteProvider<User>.Type { return RemoteProvider<User>.self }
    lazy var remote: RemoteProvider<User> = { return RemoteProvider<User>(target: self) }()
}

extension User {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var content: Content<User, UITableView, UserTableViewCell>!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.post = Post()
        let remote = self.post.remote
        let staticRemote = Post.remote
        
        self.content = Content(view: self.tableView).on(cellSetup: { (model, cell) in
            cell.setup(with: model)
        }).on(select: { (content, model, cell) in
            print("Hello \(model.email)")
        })
        
        self.content.refresh()
        
//        User.index(parameters: [:]).map { (users) in
//            print(users)
//        }
        
    }
    
    
}
