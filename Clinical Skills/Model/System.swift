//
//  System.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

class System: NSObject {
	
	var id: Int32
	var name: String
	var details: String
	
	init(id: Int32, name: String, details: String) {
		self.id = id
		self.name = name
		self.details = details
	}
	
	init(managedObject: SystemManagedObject) {
		self.id = managedObject.id
		self.name = managedObject.name
		self.details = managedObject.details
	}

}

func ==(lhs: System, rhs: System) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: System, rhs: System) -> Bool {
	return !(lhs == rhs)
}