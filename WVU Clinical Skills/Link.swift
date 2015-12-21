//
//  Link.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/17/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

@objc(Link)
class Link: NSManagedObject {

	@NSManaged var title: String
	@NSManaged var link: String
	@NSManaged var visible: Bool
	@NSManaged var systems: NSMutableSet?
	
	func addSystem(system: System) {
		if self.systems == nil {
			self.systems = NSMutableSet()
		}
		self.systems?.addObject(system)
	}
	
	func toString() -> String {
		return "\(self.title) -> \(self.link)"
	}
	
}