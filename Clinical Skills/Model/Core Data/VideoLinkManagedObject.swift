//
//  VideoLinkManagedObject.swift
//  Clinical Skills
//
//  Created by Nick on 3/10/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import CoreData

@objc(VideoLinkManagedObject)
class VideoLinkManagedObject : NSManagedObject {
	
	static let entityName = "VideoLink"
	struct propertyKeys {
		static let id = "id"
		static let title = "title"
		static let link = "link"
		static let specialTest = "special_test"
		static let examTechnique = "exam_technique"
	}
	
	@NSManaged var id: Int32
	@NSManaged var title: String
	@NSManaged var link: String
	@NSManaged var specialTest: SpecialTestManagedObject?
	@NSManaged var examTechnique: ExamTechniqueManagedObject?

	override var description: String {
		get {
			return "ID: \(self.id)) \(self.title)"
		}
	}
	
}

func ==(lhs: VideoLinkManagedObject, rhs: VideoLinkManagedObject) -> Bool {
	return (lhs.id == rhs.id) && (lhs.title == rhs.title)
}

func !=(lhs: VideoLinkManagedObject, rhs: VideoLinkManagedObject) -> Bool {
	return !(lhs == rhs)
}

func ==(lhs: VideoLinkManagedObject, rhs: VideoLink) -> Bool {
	return (lhs.id == rhs.id) && (lhs.title == rhs.title)
}

func !=(lhs: VideoLinkManagedObject, rhs: VideoLink) -> Bool {
	return !(lhs == rhs)
}