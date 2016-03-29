//
//  SpecialTest.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class SpecialTest {
	
	var id: Int32
	var name: String
	var positiveSign: String
	var indication: String
	var notes: String
	var component: Component
	var videoLinks: [VideoLink]
	
	init(component: Component, id: Int32, name: String, positiveSign: String, indication: String, notes: String) {
		self.id = id
		self.name = name
		self.positiveSign = positiveSign
		self.indication = indication
		self.notes = notes
		self.component = component
		self.videoLinks = [VideoLink]()
	}
	
	class func specialTestFromManagedObject(managedSpecialTest: SpecialTestManagedObject) -> SpecialTest {
		let id = Int32(managedSpecialTest.id)
		let name = managedSpecialTest.name
		let positiveSign = managedSpecialTest.positiveSign
		let indication = managedSpecialTest.indication
		let notes = managedSpecialTest.notes
		let component = Component.componentFromManagedObject(managedSpecialTest.component)
		return SpecialTest(component: component, id: id, name: name, positiveSign: positiveSign, indication: indication, notes: notes)
	}
	
}