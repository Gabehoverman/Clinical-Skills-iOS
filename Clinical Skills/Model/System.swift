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
	var components: [Component]
	
	init(id: Int32, name: String, details: String) {
		self.id = id
		self.name = name
		self.details = details
		self.components = []
	}
	
	class func systemFromManagedObject(systemManagedObject: SystemManagedObject) -> System {
		let id = systemManagedObject.id
		let name = systemManagedObject.name
		let details = systemManagedObject.details
		return System(id: id, name: name, details: details)
	}
	
}