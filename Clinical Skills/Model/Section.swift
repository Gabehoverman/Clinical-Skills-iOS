//
//  Section.swift
//  Clinical Skills
//
//  Created by Gabriel Hoverman on 10/12/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation

struct Section {
    var title: String!
    var items: [String]!
    var expanded: Bool!
    
    init(title: String, items: [String], expanded: Bool = false) {
        self.title = title
        self.items = items
        self.expanded = expanded
    }
}

/**var sections = [Section]()

sections = [
    Section(name: "Mac", items: ["MacBook", "MacBook Air", "MacBook Pro", "iMac", "Mac Pro", "Mac mini", "Accessories", "OS X El Capitan"]),
    Section(name: "iPad", items: ["iPad Pro", "iPad Air 2", "iPad mini 4", "Accessories"]),
    Section(name: "iPhone", items: ["iPhone 6s", "iPhone 6", "iPhone SE", "Accessories"])
]*/
