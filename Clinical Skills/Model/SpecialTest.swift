//
//  SpecialTest.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class SpecialTest {
	
	var id: Int
	var name: String
	var positiveSign: String
	var indication: String
	var notes: String
	var component: Component
	
	init(component: Component, id: Int, name: String, positiveSign: String, indication: String, notes: String) {
		self.id = id
		self.name = name
		self.positiveSign = positiveSign
		self.indication = indication
		self.notes = notes
		self.component = component
	}
	
}