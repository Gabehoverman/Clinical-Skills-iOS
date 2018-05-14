//
//  Video.swift
//  Clinical Skills
//
//  Created by Gabriel Hoverman on 8/30/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation

class Video: NSObject {
    
    var id: Int32
    var title: String
    var url: String
    var descrip: String
    
    init(id: Int32, title: String, url: String, descrip: String) {
        self.id = id
        self.title = title
        self.url = url
        self.descrip = descrip
    }
    
    init(managedObject: SystemManagedObject) {
        self.id = managedObject.id
        self.title = managedObject.title
        self.url = managedObject.url
        self.descrip = managedObject.description
    }
    
}
