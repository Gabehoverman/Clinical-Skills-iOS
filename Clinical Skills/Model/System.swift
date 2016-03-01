//
//  System.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

class System: NSObject {
	
	var name: String
	var details: String
	var visible: Bool
	var parentName: String?
	var subsystems: NSMutableSet
	var links: NSMutableSet
	
	override var description: String {
		get {
			return "(Visible: \(self.visible)) \(self.name): \(self.details)"
		}
	}
	
	init(name: String, details: String, visible: Bool, parentName: String?, subsystems: NSMutableSet, links: NSMutableSet) {
		self.name = name
		self.details = details
		self.visible = visible
		self.parentName = parentName
		self.subsystems = subsystems
		self.links = links
	}
	
	convenience init(name: String, details: String, visible: Bool, parentName: String, links: NSMutableSet) {
		self.init(name: name, details: details, visible: visible, parentName: parentName, subsystems: NSMutableSet(), links: links)
	}
	
	convenience init(name: String, details: String, visible: Bool, links: NSMutableSet) {
		self.init(name: name, details: details, visible: visible, parentName: nil, subsystems: NSMutableSet(), links: links)
	}
	
	func addSubsystem(subsystem: System) {
		self.subsystems.addObject(subsystems)
	}
	
	func addLink(link: Link) {
		self.links.addObject(link)
	}
	
	class func systemFromManagedObject(systemManagedObject: SystemManagedObject) -> System {
		let name = systemManagedObject.name
		let details = systemManagedObject.details
		let visible = systemManagedObject.visible
		let links = systemManagedObject.links
		let parentName = systemManagedObject.parentName
		let subsystems = systemManagedObject.subsystems
		return System(name: name, details: details, visible: visible, parentName: parentName, subsystems: subsystems, links: links)
	}
	
}