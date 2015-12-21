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
class DataHelper: NSObject, NSURLConnectionDataDelegate {
	
	// MARK: - Properties
	
	let SHOULD_SEED = true
	let SHOULD_PRINT_DATASTORE_CONTENTS = false
	
	let baseURLPath = "http://6a28aead.ngrok.io/"
	
	let context: NSManagedObjectContext
	
	var jsonData: NSMutableData?
	
	// MARK: - Initializers
	
	init(context: NSManagedObjectContext) {
		self.context = context
		super.init()
		
		if self.SHOULD_SEED {
			self.seed()
		}
		
		if self.SHOULD_PRINT_DATASTORE_CONTENTS {
			NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("printContents"), name: "SHOULD_PRINT_DATASTORE_CONTENTS", object: nil)
		}
	}
	
	// MARK: - Seed Methods
	
	func seed() {
		//self.localSeed()
		self.remoteSeed()
	}
	
	func localSeed() {
		//TODO: Implement Local Seed
	}
	
	func remoteSeed() {
		let urlPath = self.baseURLPath + "systems/all.json"
		if let url = NSURL(string: urlPath) {
			let request = NSURLRequest(URL: url)
			if let connection = NSURLConnection(request: request, delegate: self, startImmediately: false) {
				connection.start()
			}
		}
	}
	
	// MARK: - Remote Connection
	
	func connection(connection: NSURLConnection, didReceiveData data: NSData) {
		if self.jsonData == nil {
			self.jsonData = NSMutableData()
		}
		self.jsonData!.appendData(data)
	}
	
	func connectionDidFinishLoading(connection: NSURLConnection) {
		if let data = self.jsonData {
			let json = JSON(data: data)
			self.parseSystem(json)
		} else {
			print("No Data Received")
		}
		let nc = NSNotificationCenter.defaultCenter()
		nc.postNotificationName("SHOULD_PRINT_DATASTORE_CONTENTS", object: nil)
		nc.postNotificationName("ReceivedSystemData", object: nil)
	}
	
	func connection(connection: NSURLConnection, didFailWithError error: NSError) {
		print("Error: \(error.localizedDescription)")
	}
	
	// MARK: - JSON Parsing
	
	func parseSystem(json: JSON) {
		for (_, system) in json {
			if !self.checkForDuplicate("System", key: "systemName", value: system["name"].string!) {
				let newSystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: self.context) as! System
				newSystem.systemName = system["name"].string!
				newSystem.systemDescription = system["description"].string!
				newSystem.visible = system["visible"].bool!
				
				if let parentName = system["parent_system"].dictionary?["name"]?.string {
					self.parseParentSystem(newSystem, parentName: parentName)
				}
				
				if system["subsystems"].array?.count != 0 {
					self.parseSubsystems(system["name"].string!, subsystemsJSON: system["subsystems"].array!)
				}
				
				self.parseLinks(newSystem, linksJSON: system["links"].array!)
			}
		}
		self.saveContext()
	}
	
	func parseParentSystem(system: System, parentName: String) {
		let parentFetchRequest = NSFetchRequest(entityName: "System")
		parentFetchRequest.predicate = NSPredicate(format: "%K = %@", "systemName", parentName)
		if let parentSystem = try! self.context.executeFetchRequest(parentFetchRequest).first as? System {
			system.parentSystem = parentSystem
		}
	}
	
	func parseSubsystems(parentName: String, subsystemsJSON: [JSON]) {
		for subsystemJSON in subsystemsJSON {
			if let subsystemDict = subsystemJSON.dictionary {
				if !self.checkForDuplicate("System", key: "systemName", value: subsystemDict["name"]!.string!) {
					let newSubsystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: self.context) as! System
					newSubsystem.systemName = subsystemDict["name"]!.string!
					newSubsystem.systemDescription = subsystemDict["description"]!.string!
					newSubsystem.visible = subsystemDict["visible"]!.bool!
					self.parseLinks(newSubsystem, linksJSON: subsystemDict["links"]!.array!)
					let parentSystemFetchRequest = NSFetchRequest(entityName: "System")
					parentSystemFetchRequest.predicate = NSPredicate(format: "%K = %@", "systemName", parentName)
					let parentSystem = try! self.context.executeFetchRequest(parentSystemFetchRequest).first as! System
					newSubsystem.parentSystem = parentSystem
				}
			}
		}
		self.saveContext()
	}
	
	func parseLinks(system: System, linksJSON: [JSON]) {
		//TODO: Prevent Duplicate Links
		for linkJSON in linksJSON {
			let linkDict = linkJSON.dictionary!
//			if !self.checkForDuplicate("Link", key: "title", value: linkDict["title"]!.string!) {
				let newLink = NSEntityDescription.insertNewObjectForEntityForName("Link", inManagedObjectContext: self.context) as! Link
				newLink.title = linkDict["title"]!.string!
				newLink.link = linkDict["link"]!.string!
				newLink.visible = linkDict["visible"]!.bool!
				newLink.addSystem(system)
				system.addLink(newLink)
//			} else {
//				let linkFetchRequest = NSFetchRequest(entityName: "Link")
//				linkFetchRequest.predicate = NSPredicate(format: "%K = %@", "title", linkDict["title"]!.string!)
//				if let link = try! self.context.executeFetchRequest(linkFetchRequest).first as? Link {
//					link.addSystem(system)
//					system.addLink(link)
//				}
//			}
		}
		self.saveContext()
	}
	
	// MARK: - Database Printing
	
	/**
		Prints the entire contents of the database with sections separated by a newline
	*/
	func printContents() {
		self.printAllSystems()
		print("")
		self.printAllSubsystems()
		print("")
		self.printAllLinks()
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
			print("\t\(system.systemName)")
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
			print("\t\(subsystem.parentSystem!.systemName):")
			print("\t\t- \(subsystem.systemName)")
		}
	}
	
	func printAllLinks() {
		let linkFetchRequest = NSFetchRequest(entityName: "Link")
		linkFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		let allLinks = try! self.context.executeFetchRequest(linkFetchRequest) as! [Link]
		print("LINKS")
		for link in allLinks {
			print("\t\(link.title)")
		}
	}
	
	// MARK: - Utility Methods
	
	func checkForDuplicate(entityName: String, key: String, value: CVarArgType) -> Bool {
		let duplicateCheckRequest = NSFetchRequest(entityName: entityName)
		duplicateCheckRequest.predicate = NSPredicate(format: "%K == %@", key, value)
		do {
			let results = try self.context.executeFetchRequest(duplicateCheckRequest)
			return results.count != 0
		} catch {
			print("Error in Duplicate Fetch Request")
		}
		print("Duplicate Found")
		return true
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
	
}
