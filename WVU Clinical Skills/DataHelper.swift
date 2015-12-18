//
//  DataHelper.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/14/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

/**
	Utility for Seeding and Displaying the Database
*/
class DataHelper: NSObject {
	
	let context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	func seed() {
		self.seedSystems()
		self.seedSubsystems()
	}
	
	/**
		Inserts System seed data into the database
	*/
	func seedSystems() {
		
		if let jsonFilePath = NSBundle.mainBundle().pathForResource("systems", ofType: "json") {
			if let jsonData = NSData(contentsOfFile: jsonFilePath) {
				let json = JSON(data: jsonData)
				for (_, system) in json {
					let duplicateCheckRequest = NSFetchRequest(entityName: "System")
					duplicateCheckRequest.predicate = NSPredicate(format: "systemName = %@", system["name"].string!)
					let results = try! self.context.executeFetchRequest(duplicateCheckRequest)
					if results.count == 0 {
						let newSystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: self.context) as! System
						newSystem.systemName = system["name"].string!
						newSystem.systemDescription = system["description"].string!
						newSystem.visible = system["visible"].bool!
						newSystem.parentSystem = nil
						newSystem.subsystems = nil
					}
				}
				self.saveContext()
			}
		}
	}
	
	/**
		Inserts Subsystems seed data into the database
	*/
	func seedSubsystems() {
		
		if let jsonFilePath = NSBundle.mainBundle().pathForResource("subsystems", ofType: "json") {
			if let jsonData = NSData(contentsOfFile: jsonFilePath) {
				let json = JSON(data: jsonData)
				for (_, subsystem) in json {
					let duplicateCheckRequest = NSFetchRequest(entityName: "System")
					duplicateCheckRequest.predicate = NSPredicate(format: "systemName = %@", subsystem["name"].string!)
					let results = try! self.context.executeFetchRequest(duplicateCheckRequest)
					if results.count == 0 {
						let newSubsystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: self.context) as! System
						newSubsystem.systemName = subsystem["name"].string!
						newSubsystem.systemDescription = subsystem["description"].string!
						newSubsystem.visible = subsystem["visible"].bool!
						let parentSystemFetchRequest = NSFetchRequest(entityName: "System")
						parentSystemFetchRequest.predicate = NSPredicate(format: "systemName = %@", subsystem["parentSystemName"].string!)
						let parentSystem = try! self.context.executeFetchRequest(parentSystemFetchRequest).first as! System
						newSubsystem.parentSystem = parentSystem
						newSubsystem.subsystems = nil
					}
				}
				self.saveContext()
			}
		}
	}
	
	/**
		Saves the Managed Context with error handling
	*/
	func saveContext() {
		do {
			try self.context.save()
		} catch {
			print("Error saving the context")
		}
	}
	
	/**
		Prints the entire contents of the database with sections separated by a newline
	*/
	func printContents() {
		self.printAllSystems()
		print("")
		self.printAllSubsystems()
	}
	
	/**
		Prints all System data currently in the database
	*/
	func printAllSystems() {
		let systemFetchRequest = NSFetchRequest(entityName: "System")
		systemFetchRequest.predicate = NSPredicate(format: "parentSystem = nil")
		systemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "systemName", ascending: true)]
		let allSystems = (try! self.context.executeFetchRequest(systemFetchRequest)) as! [System]
		print("SYSTEMS")
		for system in allSystems {
			print("\t\(system.toString())")
		}
	}
	
	/**
		Prints all Subsystem data currently in the database
	*/
	func printAllSubsystems() {
		let subsystemFetchRequest = NSFetchRequest(entityName: "System")
		subsystemFetchRequest.predicate = NSPredicate(format: "parentSystem != nil")
		subsystemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "systemName", ascending: true)]
		let allSubsystems = (try! self.context.executeFetchRequest(subsystemFetchRequest)) as! [System]
		print("SUBSYSTEMS")
		for subsystem in allSubsystems {
			print("\t\(subsystem.parentSystem!.systemName) -> \(subsystem.toString())")
		}
	}
	
}
