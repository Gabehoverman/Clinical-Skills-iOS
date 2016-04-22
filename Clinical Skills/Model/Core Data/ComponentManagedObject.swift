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
	}
	
	@NSManaged var id: Int32
	@NSManaged var name: String
	@NSManaged var inspection: String
	@NSManaged var notes: String
	@NSManaged var system: SystemManagedObject
	@NSManaged var specialTests: NSMutableSet
	
	override var description: String {
		get {
			return "ID: \(self.id)) \(self.name)"
		}
	}
	
}

func ==(lhs: ComponentManagedObject, rhs: ComponentManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: ComponentManagedObject, rhs: ComponentManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: ComponentManagedObject, rhs: Component) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: ComponentManagedObject, rhs: Component) -> Bool {
	return !(lhs == rhs)
}