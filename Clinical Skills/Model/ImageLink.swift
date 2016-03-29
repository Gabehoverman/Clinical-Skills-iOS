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
	
	class func imageLinkFromManagedObject(videoLinkManagedObject: ImageLinkManagedObject) -> ImageLink {
		let id = Int32(videoLinkManagedObject.id)
		let title = videoLinkManagedObject.title
		let link = videoLinkManagedObject.link
		let specialTest = SpecialTest.specialTestFromManagedObject(videoLinkManagedObject.specialTest)
		return ImageLink(specialTest: specialTest, id: id, title: title, link: link)
	}
}