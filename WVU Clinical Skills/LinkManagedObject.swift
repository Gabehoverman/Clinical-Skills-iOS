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
	
	@NSManaged var title: String
	@NSManaged var link: String
	@NSManaged var visible: Bool
	@NSManaged var systems: NSMutableSet
	
	override var description: String {
		get {
			return "(Managed) \(self.title) -> \(self.link)"
		}
	}
	
	func addSystem(system: SystemManagedObject) {
		self.systems.addObject(system)
	}
	
}