//
//  VideoLink.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class VideoLink {
	
	var id: Int32
	var title: String
	var link: String
	var specialTest: SpecialTest?
	var examTechnique: ExamTechnique?
	
	init(specialTest: SpecialTest, id: Int32, title: String, link: String) {
		self.id = Int32(id)
		self.title = title
		self.link = link
		self.specialTest = specialTest
		self.examTechnique = nil
	}
	
	init(examTechnique: ExamTechnique, id: Int32, title: String, link: String) {
		self.id = Int32(id)
		self.title = title
		self.link = link
		self.specialTest = nil
		self.examTechnique = examTechnique
	}
	
	init(managedObject: VideoLinkManagedObject) {
		if let specialTestManagedObject = managedObject.specialTest {
			self.specialTest = SpecialTest(managedObject: specialTestManagedObject)
		}
		if let examTechniqueManagedObject = managedObject.examTechnique {
			self.examTechnique = ExamTechnique(managedObject: examTechniqueManagedObject)
		}
		self.id = Int32(managedObject.id)
		self.title = managedObject.title
		self.link = managedObject.link
	}
	
}

func ==(lhs: VideoLink, rhs: VideoLink) -> Bool {
	return (lhs.id == rhs.id) && (lhs.title == rhs.title)
}

func !=(lhs: VideoLink, rhs: VideoLink) -> Bool {
	return !(lhs == rhs)
}