//
//  RangeOfMotion.swift
//  Clinical Skills
//
//  Created by Nick Alexander on 3/25/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class RangeOfMotion {
	
	var component: Component
	var id: Int32
	var motion: String
	var degrees: String
	var notes: String
	
	init(component: Component, id: Int32, motion: String, degrees: String, notes: String) {
		self.component = component
		self.id = id
		self.motion = motion
		self.degrees = degrees
		self.notes = notes
	}
	
	class func rangeOfMotionFromManagedObject(managedObject: RangeOfMotionManagedObject) -> RangeOfMotion {
		let component = Component.componentFromManagedObject(managedObject.component)
		let id = managedObject.id
		let motion = managedObject.motion
		let degrees = managedObject.degrees
		let notes = managedObject.notes
		return RangeOfMotion(component: component, id: id, motion: motion, degrees: degrees, notes: notes)
	}
	
}