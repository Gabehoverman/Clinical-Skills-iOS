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
	
	init(managedObject: ComponentManagedObject) {
		self.system = System(managedObject: managedObject.system)
		self.id = managedObject.id
		self.name = managedObject.name
		self.inspection = managedObject.inspection
		self.notes = managedObject.notes
	}
	
}

func ==(lhs: Component, rhs: Component) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: Component, rhs: Component) -> Bool {
	return !(lhs == rhs)
}