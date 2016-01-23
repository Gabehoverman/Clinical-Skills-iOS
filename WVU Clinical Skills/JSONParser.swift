//
//  JSONParser.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/27/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SwiftyJSON

class JSONParser : NSObject {
	
	struct dataTypes {
		static let system = "system"
		static let subsystem = "subsystem"
		static let link = "link"
		static let unknown = "unknown"
	}

	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	let json: JSON
	
	var dataType: String {
		get {
			var type = "unknown"
			for (_, subJSON) in self.json {
				if let key = subJSON.dictionary?.keys.first?.lowercaseString {
					type = key
				}
			}
			return type
		}
	}
	
	init(json: JSON) {
		self.json = json
	}
	
	convenience init(jsonData: NSData) {
		self.init(json: JSON(data: jsonData))
	}
	
	func parseSystems() -> [System] {
		var systems = [System]()
		for (_, data) in self.json {
			for (_, system) in data {
				let name = system[SystemManagedObject.propertyKeys.name].stringValue
				let details = system[SystemManagedObject.propertyKeys.details].stringValue
				let visible = system[SystemManagedObject.propertyKeys.visible].boolValue
				let links = self.parseLinksForSystemWithName(name)
				let system = System(name: name, details: details, visible: visible, links: links)
				systems.append(system)
			}
		}
		return systems
	}
	
	func parseSubsystems() -> [System] {
		var subsystems = [System]()
		for (_, data) in self.json {
			for (_, subsystem) in data {
				let name = subsystem[SystemManagedObject.propertyKeys.name].stringValue
				let details = subsystem[SystemManagedObject.propertyKeys.details].stringValue
				let visible = subsystem[SystemManagedObject.propertyKeys.visible].boolValue
				let parentName = subsystem[SystemManagedObject.propertyKeys.parentName].stringValue
				let links = self.parseLinksForSubsystemWithName(name)
				let system = System(name: name, details: details, visible: visible, parentName: parentName, links: links)
				subsystems.append(system)
			}
		}
		return subsystems
	}
	
	func parseLinksForSystemWithName(name: String) -> NSMutableSet {
		let links = NSMutableSet()
		for (_, data) in self.json {
			for (_, system) in data {
				if let systemName = system[SystemManagedObject.propertyKeys.name].string {
					if systemName == name {
						for (_, link) in system[SystemManagedObject.propertyKeys.links] {
							if let linkDict = link[LinkManagedObject.entityName.lowercaseString].dictionary {
								let title = linkDict[LinkManagedObject.propertyKeys.title]!.stringValue
								let linkString = linkDict[LinkManagedObject.propertyKeys.link]!.stringValue
								let visible = linkDict[LinkManagedObject.propertyKeys.visible]!.boolValue
								let link = Link(title: title, link: linkString, visible: visible)
								links.addObject(link)
							}
						}
					}
				}
			}
		}
		
		return links
	}
	
	func parseLinksForSubsystemWithName(name: String) -> NSMutableSet {
		let links = NSMutableSet()
		for (_, data) in self.json {
			for (_, subsystem) in data {
				if let subsystemName = subsystem[SystemManagedObject.propertyKeys.name].string {
					if subsystemName == name {
						for (_, link) in subsystem[SystemManagedObject.propertyKeys.links] {
							if let linkDict = link[LinkManagedObject.entityName.lowercaseString].dictionary {
								let title = linkDict[LinkManagedObject.propertyKeys.title]!.stringValue
								let linkString = linkDict[LinkManagedObject.propertyKeys.link]!.stringValue
								let visible = linkDict[LinkManagedObject.propertyKeys.visible]!.boolValue
								let link = Link(title: title, link: linkString, visible: visible)
								links.addObject(link)
							}
						}
					}
				}
			}
		}
		return links
	}
	
	func printJSON() {
		print(self.json)
	}
	
}