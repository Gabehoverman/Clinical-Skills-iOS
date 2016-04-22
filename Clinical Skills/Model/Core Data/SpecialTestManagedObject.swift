//
//  SpecialTestManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(SpecialTestManagedObject)
class SpecialTestManagedObject : NSManagedObject {
	
	static let entityName = "SpecialTest"
	struct propertyKeys {
		static let id = "id"
		static let name = "name"
		static let positiveSign = "positive_sign"
		static let indication = "indication"
		static let notes = "notes"
		static let component = "component"
		static let imageLinks = "image_links"
		static let videoLinks = "video_links"
	}
	
	@NSManaged var id: Int32
	@NSManaged var name: String
	@NSManaged var positiveSign: String
	@NSManaged var indication: String
	@NSManaged var notes: String
	@NSManaged var component: ComponentManagedObject
	@NSManaged var imageLinks: NSMutableSet
	@NSManaged var videoLinks: NSMutableSet
	
	override var description: String {
		get {
			return "ID: \(self.id)) \(self.name)"
		}
	}
	
}

func ==(lhs: SpecialTestManagedObject, rhs: SpecialTestManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: SpecialTestManagedObject, rhs: SpecialTestManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: SpecialTestManagedObject, rhs: SpecialTest) -> Bool {
	return (lhs.id == rhs.id) && (lhs.name == rhs.name)
}

func !=(lhs: SpecialTestManagedObject, rhs: SpecialTest) -> Bool {
	return !(lhs == rhs)
}