//
//  ManagedObjectEntityPropertyKeys.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/30/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

enum ManagedObjectEntityPropertyKeys {
	
	enum System: String {
		case Name = "systemName"
		case Description = "systemDescription"
		case Visible = "visible"
		case Links = "links"
		case Parent = "parentSystem"
		case Subsystems = "subsystems"
	}
	
	enum Subsystem: String {
		case Name = "systemName"
		case Description = "systemDescription"
		case Visible = "visible"
		case Links = "links"
		case Parent = "parentSystem"
		case ParentName = "parent_name"
		case Subsystems = "subsystems"
	}
	
	enum Link: String {
		case Title = "title"
		case Link = "link"
		case Visible = "visible"
		case Systems = "systems"
	}
	
}