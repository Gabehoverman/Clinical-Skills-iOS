//
//  ComponentManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 3/8/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import CoreData

@objc(ComponentManagedObject)
class ComponentManagedObject : NSManagedObject {
	
	static let entityName = "Component"
	struct propertyKeys {
		static let id = "id"
		static let name = "name"
		static let inspection = "inspection"
		static let notes = "notes"
		static let parentSystem = "parentSystem"
	}
	
	@NSManaged var id: Int
	@NSManaged var name: String
	@NSManaged var inspection: String
	@NSManaged var notes: String
	@NSManaged var parentSystem: SystemManagedObject
	
	override var description: String {
		get {
			return "ID: \(self.id)) \(self.name)"
		}
	}
	
}