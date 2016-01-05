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
			return "(Managed) \(self.name): \(self.details)"
		}
	}
	
	func addSubsystem(subsystem: SystemManagedObject) {
		self.subsystems.addObject(subsystem)
	}
	
	func addLink(link: LinkManagedObject) {
		self.links.addObject(link)
	}
	
}