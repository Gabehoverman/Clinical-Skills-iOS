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
	
	class func videoLinkFromManagedObject(videoLinkManagedObject: VideoLinkManagedObject) -> VideoLink {
		let id = Int32(videoLinkManagedObject.id)
		let title = videoLinkManagedObject.title
		let link = videoLinkManagedObject.link
		if videoLinkManagedObject.specialTest != nil {
			return VideoLink(specialTest: SpecialTest.specialTestFromManagedObject(videoLinkManagedObject.specialTest!), id: id, title: title, link: link)
		} else {
			return VideoLink(examTechnique: ExamTechnique.examTechniqueFromManagedObject(videoLinkManagedObject.examTechnique!), id: id, title: title, link: link)
		}
	}
	
}