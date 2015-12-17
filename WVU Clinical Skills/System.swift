//
//  System.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

/**
	Represents a high-level anatomical System of the human body
*/
@objc(System)
class System: NSManagedObject {
	
	@NSManaged var systemName: String
	@NSManaged var systemDescription : String
	@NSManaged var visible: Bool
	@NSManaged var parentSystem: System?
	@NSManaged var subsystems: NSMutableSet?
	
	func addSubsystem(subsystem: System) {
		if self.subsystems == nil {
			self.subsystems = NSMutableSet()
		}
		self.subsystems!.addObject(subsystem)
	}
	
	/**
		Returns a human-friendly string representation of the System
	
		- Returns: Human-friendly string representation of the System
	*/
	func toString() -> String {
		return "\(self.systemName): \(self.systemDescription)"
	}
	
}