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
	
	var dataType: String? {
		get {
			var type: String? = "unknown"
			for (_, subJSON) in self.json {
				type = subJSON.dictionary?.keys.first
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
	
	func parseSystems() -> [[String : AnyObject]] {
		var systemDictionaries = [[String : AnyObject]]()
		for (_, data) in self.json {
			for (_, system) in data {
				var newDictionary = [String : AnyObject]()
				newDictionary[ManagedObjectEntityPropertyKeys.System.Name.rawValue] = system[RemoteDataJSONKeys.System.Name.rawValue].string!
				newDictionary[ManagedObjectEntityPropertyKeys.System.Description.rawValue] = system[RemoteDataJSONKeys.System.Description.rawValue].string!
				newDictionary[ManagedObjectEntityPropertyKeys.System.Visible.rawValue] = system[RemoteDataJSONKeys.System.Visible.rawValue].bool!
				newDictionary[ManagedObjectEntityPropertyKeys.System.Links.rawValue] = self.parseLinksForSystemWithName(system[RemoteDataJSONKeys.System.Name.rawValue].string!)
				systemDictionaries.append(newDictionary)
			}
		}
		return systemDictionaries
	}
	
	func parseSubsystems() -> [[String : AnyObject]] {
		var subsystemDictionary = [[String : AnyObject]]()
		for (_, data) in self.json {
			for (_, subsystem) in data {
				var newDictionary = [String : AnyObject]()
				newDictionary[ManagedObjectEntityPropertyKeys.Subsystem.Name.rawValue] = subsystem[RemoteDataJSONKeys.Subsystem.Name.rawValue].string!
				newDictionary[ManagedObjectEntityPropertyKeys.Subsystem.Description.rawValue] = subsystem[RemoteDataJSONKeys.Subsystem.Description.rawValue].string!
				newDictionary[ManagedObjectEntityPropertyKeys.Subsystem.Visible.rawValue] = subsystem[RemoteDataJSONKeys.Subsystem.Visible.rawValue].bool!
				newDictionary[ManagedObjectEntityPropertyKeys.Subsystem.ParentName.rawValue] = subsystem[RemoteDataJSONKeys.Subsystem.ParentName.rawValue].string!
				newDictionary[ManagedObjectEntityPropertyKeys.Subsystem.Links.rawValue] = self.parseLinksForSubsystemWithName(subsystem[RemoteDataJSONKeys.Subsystem.Name.rawValue].string!)
				subsystemDictionary.append(newDictionary)

			}
		}
		return subsystemDictionary
	}
	
	func parseLinksForSystemWithName(name: String) -> [[String : AnyObject]] {
		var links = [[String : AnyObject]]()
		for (_, data) in self.json {
			for (_, system) in data {
				if let systemName = system.dictionary?[RemoteDataJSONKeys.System.Name.rawValue]?.string {
					if (systemName == name) {
						for (_, link) in system[ManagedObjectEntityPropertyKeys.System.Links.rawValue] {
							if let linkDict = link.dictionary?[ManagedObjectEntityNames.Link.rawValue.lowercaseString]?.dictionary {
								var dict = [String : AnyObject]()
								dict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue] = linkDict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue]?.string
								dict[ManagedObjectEntityPropertyKeys.Link.Link.rawValue] = linkDict[ManagedObjectEntityPropertyKeys.Link.Link.rawValue]?.string
								dict[ManagedObjectEntityPropertyKeys.Link.Visible.rawValue] = linkDict[ManagedObjectEntityPropertyKeys.Link.Visible.rawValue]?.bool
								links.append(dict)
							}
						}
					}
				}
			}
		}
		return links
	}
	
	func parseLinksForSubsystemWithName(name: String) -> [[String : AnyObject]] {
		var links = [[String : AnyObject]]()
		for (_, data) in self.json {
			for (_, subsystem) in data {
				if let subsystemName = subsystem.dictionary?[RemoteDataJSONKeys.Subsystem.Name.rawValue]?.string {
					if (subsystemName == name) {
						for (_, link) in subsystem[ManagedObjectEntityPropertyKeys.Subsystem.Links.rawValue] {
							if let linkDict = link.dictionary?[ManagedObjectEntityNames.Link.rawValue.lowercaseString]?.dictionary {
								var dict = [String : AnyObject]()
								dict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue] = linkDict[ManagedObjectEntityPropertyKeys.Link.Title.rawValue]?.string
								dict[ManagedObjectEntityPropertyKeys.Link.Link.rawValue] = linkDict[ManagedObjectEntityPropertyKeys.Link.Link.rawValue]?.string
								dict[ManagedObjectEntityPropertyKeys.Link.Visible.rawValue] = linkDict[ManagedObjectEntityPropertyKeys.Link.Visible.rawValue]?.bool
								links.append(dict)
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