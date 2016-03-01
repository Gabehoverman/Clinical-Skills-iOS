//
//  SystemManagedObject.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 1/4/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import UIKit
import CoreData

/**
Represents a high-level anatomical System of the human body
*/
@objc(SystemManagedObject)
class SystemManagedObject: NSManagedObject {
	
	static let entityName = "System"
	struct propertyKeys {
		static let name = "name"
		static let details = "details"
		static let visible = "visible"
		static let links = "links"
		static let parent = "parentSystem"
		static let parentName = "parent_name"
		static let subsystems = "subsystems"
	}
	
	@NSManaged var name: String
	@NSManaged var details : String
	@NSManaged var visible: Bool
	@NSManaged var parentSystem: SystemManagedObject?
	@NSManaged var subsystems: NSMutableSet
	@NSManaged var links: NSMutableSet
	
	var parentName: String? {
		get {
			if self.parentSystem != nil {
				return self.parentSystem!.name
			}
			return nil
		}
	}
	
	override var description: String {
		get {
			if self.parentSystem == nil {
				return "(Managed) [\(self.visible ? "Visible" : "Invisible")] \(self.name):\t\(self.details)"
			} else {
				return "(Managed) [\(self.visible ? "Visible" : "Invisible")] \(self.parentSystem!.name) > \(self.name): \t \(self.details)"
			}
		}
	}
	
	func addSubsystem(subsystem: SystemManagedObject) {
		self.subsystems.addObject(subsystem)
	}
	
	func addLink(link: LinkManagedObject) {
		self.links.addObject(link)
	}
	
	func equalTo(object: AnyObject?) -> Bool {
		if object != nil {
			if let systemManagedObject = object! as? SystemManagedObject {
				var equal = true
				equal = equal && self.name == systemManagedObject.name
				equal = equal && self.details == systemManagedObject.details
				equal = equal && self.visible == systemManagedObject.visible
				equal = equal && self.links == systemManagedObject.links
				return equal
			}
		}
		return false
	}
	
}