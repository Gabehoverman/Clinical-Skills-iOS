//
//  ImageLinkManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 3/13/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(ImageLinkManagedObject)
class ImageLinkManagedObject : NSManagedObject {
	
	static let entityName = "ImageLink"
	struct propertyKeys {
		static let id = "id"
		static let title = "title"
		static let link = "link"
		static let specialTest = "special_test"
	}
	
	@NSManaged var id: Int32
	@NSManaged var title: String
	@NSManaged var link: String
	@NSManaged var specialTest: SpecialTestManagedObject
	
	override var description: String {
		get {
			return "ID: \(self.id)) \(self.title)"
		}
	}
	
}