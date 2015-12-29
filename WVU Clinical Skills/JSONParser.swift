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

	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	let json: JSON
	
	init(json: JSON) {
		self.json = json
	}
	
	init(jsonData: NSData) {
		self.json = JSON(data: jsonData)
	}
	
	//		for (_, system) in json {
	//			if !self.checkForDuplicate(ManagedObjectEntityNames.System.rawValue, key: "systemName", value: system["name"].string!) {
	//				let newSystem = NSEntityDescription.insertNewObjectForEntityForName(ManagedObjectEntityNames.System.rawValue, inManagedObjectContext: self.context) as! System
	//				newSystem.systemName = system["name"].string!
	//				newSystem.systemDescription = system["description"].string!
	//				newSystem.visible = system["visible"].bool!
	//
	//				if let parentName = system["parent_system"].dictionary?["name"]?.string {
	//					self.parseParentSystem(newSystem, parentName: parentName)
	//				}
	//
	//				if system["subsystems"].array?.count != 0 {
	//					self.parseSubsystems(system["name"].string!, subsystemsJSON: system["subsystems"].array!)
	//				}
	//
	//				self.parseLinks(newSystem, linksJSON: system["links"].array!)
	//			}
	//		}
	//		self.saveContext()

	
	func parseSystems() -> [System] {
		var systems = [System]()
		for (_, data) in self.json {
			for (_, system) in data {
				//let newSystem = NSEntityDescription.insertNewObjectForEntityForName(ManagedObjectEntityNames.System.rawValue, inManagedObjectContext: self.temporaryManagedObjectContext) as! System
				if let systemEntity = NSEntityDescription.entityForName(ManagedObjectEntityNames.System.rawValue, inManagedObjectContext: self.managedObjectContext) {
					let newSystem = NSManagedObject(entity: systemEntity, insertIntoManagedObjectContext: nil) as! System
					if let systemAttributes = system.dictionary {
						newSystem.systemName = systemAttributes["name"]!.string!
						newSystem.systemDescription = systemAttributes["description"]!.string!
						newSystem.visible = systemAttributes["visible"]!.bool!
						newSystem.links = nil
						systems.append(newSystem)
					}
				}
			}
		}
		return systems
	}
	
	func parseParentSystem() -> System {
		abort()
	}
	
	func parseSubsystems() -> [System] {
		abort()
	}
	
	func parseLinks() -> [Link] {
		abort()
	}
	
	func printJSON() {
		print(self.json)
	}
	
}