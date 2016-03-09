//
//  Component.swift
//  Clinical Skills
//
//  Created by Nick on 3/8/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class Component {
	
	var id: Int
	var name: String
	var inspection: String
	var notes: String
	var parentSystem: System
	
	var description: String {
		get {
			return "ID: \(self.id)) \(self.name)"
		}
	}
	
	init(parentSystem: System, id: Int, name: String, inspection: String, notes: String) {
		self.id = id
		self.name = name
		self.inspection = inspection
		self.notes = notes
		self.parentSystem = parentSystem
	}
	
	class func componentFromManagedObject(componentManagedObject: ComponentManagedObject) -> Component {
		let id = componentManagedObject.id
		let name = componentManagedObject.name
		let inspection = componentManagedObject.inspection
		let notes = componentManagedObject.notes
		let system = System.systemFromManagedObject(componentManagedObject.parentSystem)
		return Component(parentSystem: system, id: id, name: name, inspection: inspection, notes: notes)
	}
	
}