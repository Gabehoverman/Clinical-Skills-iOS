//
//  Muscle.swift
//  Clinical Skills
//
//  Created by Nick on 3/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class Muscle {
	
	var component: Component
	var id: Int32
	var name: String
	
	init(component: Component, id: Int32, name: String) {
		self.component = component
		self.id = id
		self.name = name
	}
	
	class func muscleFromManagedObject(managedObject: MuscleManagedObject) -> Muscle {
		let component = Component.componentFromManagedObject(managedObject.component)
		let id = managedObject.id
		let name = managedObject.name
		return Muscle(component: component, id: id, name: name)
	}
	
}