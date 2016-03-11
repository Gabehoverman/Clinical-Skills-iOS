//
//  SystemManagedObject.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 1/4/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import CoreData

/**
Represents a high-level anatomical System of the human body
*/
@objc(SystemManagedObject)
class SystemManagedObject: NSManagedObject {
	
	static let entityName = "System"
	struct propertyKeys {
		static let id = "id"
		static let name = "name"
		static let details = "details"
		static let components = "components"
	}
	
	@NSManaged var id: Int32
	@NSManaged var name: String
	@NSManaged var details : String
	@NSManaged var components: NSMutableSet
	
	func equalTo(object: AnyObject?) -> Bool {
		if object != nil {
			if let systemManagedObject = object! as? SystemManagedObject {
				var equal = true
				equal = equal && self.id == systemManagedObject.id
				equal = equal && self.name == systemManagedObject.name
				equal = equal && self.details == systemManagedObject.details
				return equal
			}
		}
		return false
	}
	
}