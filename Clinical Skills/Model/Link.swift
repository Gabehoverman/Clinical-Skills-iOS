//
//  Link.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/17/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

class Link: NSObject {
	
	var title: String
	var link: String
	var visible: Bool
	var systems: NSMutableSet
	
	override var description: String {
		get {
			return "\(self.title) -> \(self.link)"
		}
	}
	
	init(title: String, link: String, visible: Bool, systems: NSMutableSet) {
		self.title = title
		self.link = link
		self.visible = visible
		self.systems = systems
	}
	
	convenience init(title: String, link: String, visible: Bool) {
		self.init(title: title, link: link, visible: visible, systems: NSMutableSet())
	}
	
	func addSystem(system: System) {
		self.systems.addObject(system)
	}
	
}