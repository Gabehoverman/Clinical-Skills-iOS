//
//  ImageLink.swift
//  Clinical Skills
//
//  Created by Nick on 3/13/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class ImageLink {
	
	var id: Int32
	var title: String
	var link: String
	var specialTest: SpecialTest
	
	init(specialTest: SpecialTest, id: Int32, title: String, link: String) {
		self.id = Int32(id)
		self.title = title
		self.link = link
		self.specialTest = specialTest
	}
	
	init(managedObject: ImageLinkManagedObject) {
		self.specialTest = SpecialTest(managedObject: managedObject.specialTest)
		self.id = Int32(managedObject.id)
		self.title = managedObject.title
		self.link = managedObject.link
	}
}

func ==(lhs: ImageLink, rhs: ImageLink) -> Bool {
	return (lhs.id == rhs.id) && (lhs.title == rhs.title)
}

func !=(lhs: ImageLink, rhs: ImageLink) -> Bool {
	return !(lhs == rhs)
}