//
//  Component.swift
//  Clinical Skills
//
//  Created by Nick on 3/8/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class Component {
	
	var system: System
	var id: Int32
	var name: String
	var inspection: String
	var notes: String
	
	var description: String {
		get {
			return "ID: \(self.id)) \(self.name)"
		}
	}
	
	init(system: System, id: Int32, name: String, inspection: String, notes: String) {
		self.system = system
		self.id = id
		self.name = name
		self.inspection = inspection
		self.notes = notes
	}
	
	class func componentFromManagedObject(componentManagedObject: ComponentManagedObject) -> Component {
		let id = componentManagedObject.id
		let name = componentManagedObject.name
		let inspection = componentManagedObject.inspection
		let notes = componentManagedObject.notes
		let system = System.systemFromManagedObject(componentManagedObject.system)
		return Component(system: system, id: id, name: name, inspection: inspection, notes: notes)
	}
	
}