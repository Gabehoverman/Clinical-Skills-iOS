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
	
	let baseURLPath = "http://aea3de69.ngrok.io/"
	
	var jsonData: NSMutableData?
	
	let context: NSManagedObjectContext
	
	
	// MARK: - Initializers
	
	init(context: NSManagedObjectContext) {
		self.context = context
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
		}
		let nc = NSNotificationCenter.defaultCenter()
		nc.postNotificationName("ReceivedSystemData", object: nil)
	}
	
	// MARK: - JSON Parsing
	
	func parseSystem(json: JSON) {
		for (_, system) in json {
			if !self.checkForDuplicate("System", key: "systemName", value: system["name"].string!) {
				let newSystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: self.context) as! System
				newSystem.systemName = system["name"].string!
				newSystem.systemDescription = system["description"].string!
				newSystem.visible = system["visible"].bool!
				
				if system["subsystems"].array?.count != 0 {
					self.parseSybsystems(system["name"].string!, subsystemsJSON: system["subsystems"].array!)
				}
				
				self.parseLinks(newSystem, linksJSON: system["links"].array!)
			}
		}
		self.saveContext()
	}
	
	func parseSybsystems(parentName: String, subsystemsJSON: [JSON]) {
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
					newSubsystem.subsystems = nil
				}
			}
		}
		self.saveContext()
	}
	
	func parseLinks(system: System, linksJSON: [JSON]) {
		for linkJSON in linksJSON {
			let linkDict = linkJSON.dictionary!
			let newLink = NSEntityDescription.insertNewObjectForEntityForName("Link", inManagedObjectContext: self.context) as! Link
			newLink.title = linkDict["title"]!.string!
			newLink.link = linkDict["link"]!.string!
			newLink.visible = linkDict["visible"]!.bool!
			newLink.system = system
			system.addLink(newLink)
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
	
	func printAllLinks() {
		let linkFetchRequest = NSFetchRequest(entityName: "Link")
		linkFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		let allLinks = try! self.context.executeFetchRequest(linkFetchRequest) as! [Link]
		print("LINKS")
		for link in allLinks {
			print("\t\(link.toString())")
		}
	}
	
	// MARK: - Utility Methods
	
	func checkForDuplicate(entityName: String, key: String, value: CVarArgType) -> Bool {
		let duplicateCheckRequest = NSFetchRequest(entityName: entityName)
		duplicateCheckRequest.predicate = NSPredicate(format: "%K = %@", key, value)
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
