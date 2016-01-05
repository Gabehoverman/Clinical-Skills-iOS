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
	
	init(jsonData: NSData) {
		self.json = JSON(data: jsonData)
	}
	
	func parseSystems() -> [System] {
		var systems = [System]()
		for (_, data) in self.json {
			for (_, system) in data {
				let name = system[RemoteDataJSONKeys.System.Name.rawValue].stringValue
				let details = system[RemoteDataJSONKeys.System.Details.rawValue].stringValue
				let visible = system[RemoteDataJSONKeys.System.Visible.rawValue].boolValue
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
				let name = subsystem[RemoteDataJSONKeys.Subsystem.Name.rawValue].stringValue
				let details = subsystem[RemoteDataJSONKeys.Subsystem.Details.rawValue].stringValue
				let visible = subsystem[RemoteDataJSONKeys.Subsystem.Visible.rawValue].boolValue
				let parentName = subsystem[RemoteDataJSONKeys.Subsystem.ParentName.rawValue].stringValue
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
				if let systemName = system[RemoteDataJSONKeys.System.Name.rawValue].string {
					if systemName == name {
						for (_, link) in system[ManagedObjectEntityPropertyKeys.System.Links.rawValue] {
							if let linkDict = link[ManagedObjectEntityNames.Link.rawValue.lowercaseString].dictionary {
								let title = linkDict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue]!.stringValue
								let linkString = linkDict[ManagedObjectEntityPropertyKeys.Link.Link.rawValue]!.stringValue
								let visible = linkDict[ManagedObjectEntityPropertyKeys.Link.Visible.rawValue]!.boolValue
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
				if let subsystemName = subsystem[RemoteDataJSONKeys.System.Name.rawValue].string {
					if subsystemName == name {
						for (_, link) in subsystem[ManagedObjectEntityPropertyKeys.System.Links.rawValue] {
							if let linkDict = link[ManagedObjectEntityNames.Link.rawValue.lowercaseString].dictionary {
								let title = linkDict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue]!.stringValue
								let linkString = linkDict[ManagedObjectEntityPropertyKeys.Link.Link.rawValue]!.stringValue
								let visible = linkDict[ManagedObjectEntityPropertyKeys.Link.Visible.rawValue]!.boolValue
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
	
	enum DataTypes: String {
		case System = "system"
		case Subsystem = "subsystem"
		case Link = "link"
		case Unknown = "unknown"
	}
	
}