////
////  DataHelper.swift
////  WVU Clinical Skills
////
////  Created by Nick on 12/14/15.
////  Copyright © 2015 Nick. All rights reserved.
////
//
//import UIKit
//import CoreData
//import SwiftyJSON
//
//// MARK: - Data Helper Class
//
///**
//	Utility for Seeding and Displaying the Database
//*/
//class DataHelper: NSObject {
//	
//	// TODO: Break up into Local and Remote Data Requests
//	// TODO: Handle all CRUD actions
//	// TODO: Revert to local storage in event of no Internet
//	
//	// MARK: - Properties
//	
//	let SHOULD_SEED = true
//	let SHOULD_PRINT_DATASTORE_CONTENTS = false
//	
//	let context: NSManagedObjectContext
//	
//	// MARK: - Initializers
//	
//	// MARK: - Seed Methods
//	
//	func seed() {
//		self.localSeed()
//	}
//	
//	func localSeed() {
//		//TODO: Implement Local Seed
//	}
//	
//	// MARK: - Remote Connection
//	
//	// MARK: - JSON Parsing
//	
//	func parseSystem(json: JSON) {
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
//	}
//	
//	func parseParentSystem(system: System, parentName: String) {
//		let parentFetchRequest = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
//		parentFetchRequest.predicate = NSPredicate(format: "%K = %@", "systemName", parentName)
//		if let parentSystem = try! self.context.executeFetchRequest(parentFetchRequest).first as? System {
//			system.parentSystem = parentSystem
//		}
//	}
//	
//	func parseSubsystems(parentName: String, subsystemsJSON: [JSON]) {
//		for subsystemJSON in subsystemsJSON {
//			if let subsystemDict = subsystemJSON.dictionary {
//				if !self.checkForDuplicate(ManagedObjectEntityNames.System.rawValue, key: "systemName", value: subsystemDict["name"]!.string!) {
//					let newSubsystem = NSEntityDescription.insertNewObjectForEntityForName(ManagedObjectEntityNames.System.rawValue, inManagedObjectContext: self.context) as! System
//					newSubsystem.systemName = subsystemDict["name"]!.string!
//					newSubsystem.systemDescription = subsystemDict["description"]!.string!
//					newSubsystem.visible = subsystemDict["visible"]!.bool!
//					self.parseLinks(newSubsystem, linksJSON: subsystemDict["links"]!.array!)
//					let parentSystemFetchRequest = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
//					parentSystemFetchRequest.predicate = NSPredicate(format: "%K = %@", "systemName", parentName)
//					let parentSystem = try! self.context.executeFetchRequest(parentSystemFetchRequest).first as! System
//					newSubsystem.parentSystem = parentSystem
//				}
//			}
//		}
//		self.saveContext()
//	}
//	
//	func parseLinks(system: System, linksJSON: [JSON]) {
//		//TODO: Prevent Duplicate Links
//		for linkJSON in linksJSON {
//			let linkDict = linkJSON.dictionary!
////			if !self.checkForDuplicate(ManagedObjectEntityNames.Link.rawValue, key: "title", value: linkDict["title"]!.string!) {
//				let newLink = NSEntityDescription.insertNewObjectForEntityForName(ManagedObjectEntityNames.Link.rawValue, inManagedObjectContext: self.context) as! Link
//				newLink.title = linkDict["title"]!.string!
//				newLink.link = linkDict["link"]!.string!
//				newLink.visible = linkDict["visible"]!.bool!
//				newLink.addSystem(system)
//				system.addLink(newLink)
////			} else {
////				let linkFetchRequest = NSFetchRequest(entityName: ManagedObjectEntityNames.Link.rawValue)
////				linkFetchRequest.predicate = NSPredicate(format: "%K = %@", "title", linkDict["title"]!.string!)
////				if let link = try! self.context.executeFetchRequest(linkFetchRequest).first as? Link {
////					link.addSystem(system)
////					system.addLink(link)
////				}
////			}
//		}
//		self.saveContext()
//	}
//	
//	// MARK: - Database Printing
//	
//	/**
//		Prints the entire contents of the database with sections separated by a newline
//	*/
//	func printContents() {
//		self.printAllSystems()
//		print("")
//		self.printAllSubsystems()
//		print("")
//		self.printAllLinks()
//	}
//	
//	/**
//		Prints all System data currently in the database
//	*/
//	func printAllSystems() {
//		let systemFetchRequest = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
//		systemFetchRequest.predicate = NSPredicate(format: "parentSystem = nil")
//		systemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "systemName", ascending: true)]
//		let allSystems = (try! self.context.executeFetchRequest(systemFetchRequest)) as! [System]
//		print("SYSTEMS")
//		for system in allSystems {
//			print("\t\(system.systemName)")
//		}
//	}
//	
//	/**
//		Prints all Subsystem data currently in the database
//	*/
//	func printAllSubsystems() {
//		let subsystemFetchRequest = NSFetchRequest(entityName: ManagedObjectEntityNames.System.rawValue)
//		subsystemFetchRequest.predicate = NSPredicate(format: "parentSystem != nil")
//		subsystemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "systemName", ascending: true)]
//		let allSubsystems = (try! self.context.executeFetchRequest(subsystemFetchRequest)) as! [System]
//		print("SUBSYSTEMS")
//		for subsystem in allSubsystems {
//			print("\t\(subsystem.parentSystem!.systemName):")
//			print("\t\t- \(subsystem.systemName)")
//		}
//	}
//	
//	func printAllLinks() {
//		let linkFetchRequest = NSFetchRequest(entityName: ManagedObjectEntityNames.Link.rawValue)
//		linkFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//		let allLinks = try! self.context.executeFetchRequest(linkFetchRequest) as! [Link]
//		print("LINKS")
//		for link in allLinks {
//			print("\t\(link.title)")
//		}
//	}
//	
//	// MARK: - Utility Methods
//	
//	func checkForDuplicate(entityName: String, key: String, value: CVarArgType) -> Bool {
//		let duplicateCheckRequest = NSFetchRequest(entityName: entityName)
//		duplicateCheckRequest.predicate = NSPredicate(format: "%K == %@", key, value)
//		do {
//			let results = try self.context.executeFetchRequest(duplicateCheckRequest)
//			return results.count != 0
//		} catch {
//			print("Error in Duplicate Fetch Request")
//		}
//		print("Duplicate Found")
//		return true
//	}
//	
//	/**
//	Saves the Managed Context with error handling
//	*/
//	func saveContext() {
//		do {
//			try self.context.save()
//		} catch {
//			print("Error saving the context")
//		}
//	}
//	
//}
