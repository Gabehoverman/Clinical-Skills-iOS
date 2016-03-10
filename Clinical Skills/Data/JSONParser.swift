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
		static let component = "component"
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
				let id = system[SystemManagedObject.propertyKeys.id].intValue
				let name = system[SystemManagedObject.propertyKeys.name].stringValue
				let details = system[SystemManagedObject.propertyKeys.details].stringValue
				let system = System(id: id, name: name, details: details)
				systems.append(system)
			}
		}
		return systems
	}
	
	func parseComponents(system: System) -> [Component] {
		var components = [Component]()
		for (_, data) in self.json {
			for (_, component) in data {
				let id = component[ComponentManagedObject.propertyKeys.id].intValue
				let name = component[ComponentManagedObject.propertyKeys.name].stringValue
				let inspection = component[ComponentManagedObject.propertyKeys.inspection].stringValue
				let notes = component[ComponentManagedObject.propertyKeys.notes].stringValue
				components.append(Component(parent: system, id: id, name: name, inspection: inspection, notes: notes))
			}
		}
		return components
	}
	
	func printJSON() {
		print(self.json)
	}
	
}