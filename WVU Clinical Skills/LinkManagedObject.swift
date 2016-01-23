//
//  LinkManagedObject.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 1/4/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import UIKit
import CoreData

@objc(LinkManagedObject)
class LinkManagedObject: NSManagedObject {
	
	static let entityName = "Link"
	struct propertyKeys {
		static let title = "title"
		static let link = "link"
		static let visible = "visible"
		static let systems = "systems"
	}
	
	@NSManaged var title: String
	@NSManaged var link: String
	@NSManaged var visible: Bool
	@NSManaged var systems: NSMutableSet
	
	override var description: String {
		get {
			return "(Managed) [\(self.visible ? "Visible" : "Invisible")] \(self.title): \t \(self.link)"
		}
	}
	
	func addSystem(system: SystemManagedObject) {
		self.systems.addObject(system)
	}
	
	func equalTo(object: AnyObject?) -> Bool {
		if object != nil {
			if let linkManagedObject = object! as? LinkManagedObject {
				var equal = false
				equal = equal && self.title == linkManagedObject.title
				equal = equal && self.link == linkManagedObject.link
				equal = equal && self.visible == linkManagedObject.visible
				equal = equal && self.systems == linkManagedObject.systems
				return equal
			}
		}
		return false
	}
	
}