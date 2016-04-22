//
//  JSONParser.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/27/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SwiftyJSON

class JSONParser : NSObject {
	
	// MARK: - JSON Data Type Keys
	
	struct dataTypes {
		static let system = "system"
		static let examTechnique = "exam_technique"
		static let component = "component"
		static let palpation = "palpation"
		static let rangeOfMotion = "range_of_motion"
		static let muscle = "muscle"
		static let specialTest = "special_test"
		static let imageLink = "image_link"
		static let videoLink = "video_link"
		static let empty = "empty"
		static let unknown = "unknown"
	}
	
	// MARK: - Properties

	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	let json: JSON
	
	var dataType: String {
		get {
			var type = "unknown"
			if self.json.isEmpty {
				type = "empty"
			}
			for (_, subJSON) in self.json {
				if let key = subJSON.dictionary?.keys.first?.lowercaseString {
					type = key
				}
			}
			return type
		}
	}
	
	// MARK: - Initializers
	
	init(rawData: NSData) {
		self.json = JSON(data: rawData)
	}
	
	// MARK: - Parse Methods
	
	func parseSystems() -> [System] {
		var systems = [System]()
		for (_, data) in self.json {
			for (_, system) in data {
				let id = Int32(system[SystemManagedObject.propertyKeys.id].intValue)
				let name = system[SystemManagedObject.propertyKeys.name].stringValue
				let details = system[SystemManagedObject.propertyKeys.details].stringValue
				let system = System(id: id, name: name, details: details)
				systems.append(system)
			}
		}
		return systems
	}
	
	func parseExamTechniques(system: System) -> [ExamTechnique] {
		var examTechniques = [ExamTechnique]()
		for (_, data) in self.json {
			for (_, examTechnique) in data {
				let id = Int32(examTechnique[ExamTechniqueManagedObject.propertyKeys.id].intValue)
				let name = examTechnique[ExamTechniqueManagedObject.propertyKeys.name].stringValue
				let details = examTechnique[ExamTechniqueManagedObject.propertyKeys.details].stringValue
				examTechniques.append(ExamTechnique(system: system, id: id, name: name, details: details))
			}
		}
		return examTechniques
	}
	
	func parseComponents(system: System) -> [Component] {
		var components = [Component]()
		for (_, data) in self.json {
			for (_, component) in data {
				let id = Int32(component[ComponentManagedObject.propertyKeys.id].intValue)
				let name = component[ComponentManagedObject.propertyKeys.name].stringValue
				let inspection = component[ComponentManagedObject.propertyKeys.inspection].stringValue
				let notes = component[ComponentManagedObject.propertyKeys.notes].stringValue
				components.append(Component(system: system, id: id, name: name, inspection: inspection, notes: notes))
			}
		}
		return components
	}
	
	func parsePalpations(component: Component) -> [Palpation] {
		var palpations = [Palpation]()
		for (_, data) in self.json {
			for (_, palpation) in data {
				let id = Int32(palpation[MuscleManagedObject.propertyKeys.id].intValue)
				let structure = palpation[PalpationManagedObject.propertyKeys.structure].stringValue
				let details = palpation[PalpationManagedObject.propertyKeys.details].stringValue
				let notes = palpation[PalpationManagedObject.propertyKeys.notes].stringValue
				palpations.append(Palpation(component: component, id: id, structure: structure, details: details, notes: notes))
			}
		}
		return palpations
	}
	
	func parseRangesOfMotion(component: Component) -> [RangeOfMotion] {
		var rangesOfMotion = [RangeOfMotion]()
		for (_, data) in self.json {
			for (_, rangeOfMotion) in data {
				let id = Int32(rangeOfMotion[RangeOfMotionManagedObject.propertyKeys.id].intValue)
				let motion = rangeOfMotion[RangeOfMotionManagedObject.propertyKeys.motion].stringValue
				let degrees = rangeOfMotion[RangeOfMotionManagedObject.propertyKeys.degrees].stringValue
				let notes = rangeOfMotion[RangeOfMotionManagedObject.propertyKeys.notes].stringValue
				rangesOfMotion.append(RangeOfMotion(component: component, id: id, motion: motion, degrees: degrees, notes: notes))
			}
		}
		return rangesOfMotion
	}
	
	func parseMuscles(component: Component) -> [Muscle] {
		var muscles = [Muscle]()
		for (_, data) in self.json {
			for (_, muscle) in data {
				let id = Int32(muscle[MuscleManagedObject.propertyKeys.id].intValue)
				let name = muscle[MuscleManagedObject.propertyKeys.name].stringValue
				muscles.append(Muscle(component: component, id: id, name: name))
			}
		}
		return muscles
	}
	
	func parseSpecialTests(component: Component) -> [SpecialTest] {
		var specialTests = [SpecialTest]()
		for (_, data) in self.json {
			for (_, specialTest) in data {
				let id = Int32(specialTest[SpecialTestManagedObject.propertyKeys.id].intValue)
				let name = specialTest[SpecialTestManagedObject.propertyKeys.name].stringValue
				let positiveSign = specialTest[SpecialTestManagedObject.propertyKeys.positiveSign].stringValue
				let indication = specialTest[SpecialTestManagedObject.propertyKeys.indication].stringValue
				let notes = specialTest[SpecialTestManagedObject.propertyKeys.notes].stringValue
				specialTests.append(SpecialTest(component: component, id: id, name: name, positiveSign: positiveSign, indication: indication, notes: notes))
			}
		}
		return specialTests
	}
	
	func parseImageLinks(specialTest: SpecialTest) -> [ImageLink] {
		var imageLinks = [ImageLink]()
		for (_, data) in self.json {
			for (_, imageLink) in data {
				let id = Int32(imageLink[ImageLinkManagedObject.propertyKeys.id].intValue)
				let title = imageLink[ImageLinkManagedObject.propertyKeys.title].stringValue
				let link = imageLink[ImageLinkManagedObject.propertyKeys.link].stringValue
				imageLinks.append(ImageLink(specialTest: specialTest, id: id, title: title, link: link))
			}
		}
		return imageLinks
	}
	
	func parseVideoLinks(specialTest: SpecialTest) -> [VideoLink] {
		var videoLinks = [VideoLink]()
		for (_, data) in self.json {
			for (_, videoLink) in data {
				let id = Int32(videoLink[VideoLinkManagedObject.propertyKeys.id].intValue)
				let title = videoLink[VideoLinkManagedObject.propertyKeys.title].stringValue
				let link = videoLink[VideoLinkManagedObject.propertyKeys.link].stringValue
				videoLinks.append(VideoLink(specialTest: specialTest, id: id, title: title, link: link))
			}
		}
		return videoLinks
	}
	
	func parseVideoLinks(examTechnqiue: ExamTechnique) -> [VideoLink] {
		var videoLinks = [VideoLink]()
		for (_, data) in self.json {
			for (_, videoLink) in data {
				let id = Int32(videoLink[VideoLinkManagedObject.propertyKeys.id].intValue)
				let title = videoLink[VideoLinkManagedObject.propertyKeys.title].stringValue
				let link = videoLink[VideoLinkManagedObject.propertyKeys.link].stringValue
				videoLinks.append(VideoLink(examTechnique: examTechnqiue, id: id, title: title, link: link))
			}
		}
		return videoLinks
	}
	
	// MARK: - Print Methods
	
	func printJSON() {
		print(self.json)
	}
	
}