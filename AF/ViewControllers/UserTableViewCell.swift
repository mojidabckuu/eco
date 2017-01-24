//
//  UserTableViewCell.swift
//  AF
//
//  Created by Vlad Gorbenko on 1/23/17.
//  Copyright © 2017 Vlad Gorbenko. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell, ContentCell {
    
    var raiser: ActionRaiser?
    
    func setup(with user: User) {
        self.textLabel?.text = user.email
        self.detailTextLabel?.text = user.id
    }
    
}
