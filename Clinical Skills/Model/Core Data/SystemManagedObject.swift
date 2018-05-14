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
		static let rangesofMotion = "ranges_of_motion"
	}
	
	@NSManaged var id: Int32
	@NSManaged var name: String
	@NSManaged var details : String
	@NSManaged var components: NSMutableSet
	@NSManaged var rangesOfMotion: NSMutableSet
    @NSManaged var url: String
    @NSManaged var title: String
	
	override var description: String {
		get {
			return "ID: \(self.id)) \(self.name)"
		}
	}
	
}

func ==(lhs: SystemManagedObject, rhs: SystemManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: SystemManagedObject, rhs: SystemManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: SystemManagedObject, rhs: System) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: SystemManagedObject, rhs: System) -> Bool {
	return !(lhs == rhs)
}
