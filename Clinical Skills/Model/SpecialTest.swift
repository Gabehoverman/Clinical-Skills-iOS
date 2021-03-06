//
//  SpecialTest.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class SpecialTest {
	
	var component: Component
	var id: Int32
	var name: String
	var positiveSign: String
	var indication: String
	var notes: String
    var howTo: String
	
    init(component: Component, id: Int32, name: String, positiveSign: String, indication: String, notes: String, howTo: String) {
		self.component = component
		self.id = id
		self.name = name
		self.positiveSign = positiveSign
		self.indication = indication
		self.notes = notes
        self.howTo = howTo
	}
	
	init(managedObject: SpecialTestManagedObject) {
		self.component = Component(managedObject: managedObject.component)
		self.id = Int32(managedObject.id)
		self.name = managedObject.name
		self.positiveSign = managedObject.positiveSign
		self.indication = managedObject.indication
		self.notes = managedObject.notes
        self.howTo = managedObject.howTo
	}
	
}

func ==(lhs: SpecialTest, rhs: SpecialTest) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: SpecialTest, rhs: SpecialTest) -> Bool {
	return !(lhs == rhs)
}
