//
//  RemoteDataJSONKeys.swift
//  WVU Clinical Skills
//
//  Created by Nick on 12/30/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

enum RemoteDataJSONKeys {
	
	enum System: String {
		case Name = "name"
		case Description = "description"
		case Visible = "visible"
		case Links = "links"
	}
	
	enum Subsystem: String {
		case Name = "name"
		case Description = "description"
		case Visible = "visible"
		case Links = "links"
		case ParentName = "parent_name"
	}
	
	enum Link: String {
		case Title = "title"
		case Link = "link"
		case Visible = "visible"
	}
	
}