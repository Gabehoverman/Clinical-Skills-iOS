//
//  RemoteUrls.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

enum DataURLStrings {
	
	enum Local: String {
		case Systems = "http://localhost:3000/data/systems.json"
		case Subsystems = "http://localhost:3000/data/subsystems.json"
		case Detailed = "http://localhost:3000/data/detailed.json"
		case Links = "http://localhost:3000/data/links.json"
	}
	
	enum Remote: String {
		case Systems = "https://wvusom-data-server.herokuapp.com/data/systems.json"
		case Subsystems = "https://wvusom-data-server.herokuapp.com/data/subsystems.json"
		case Detailed = "https://wvusom-data-server.herokuapp.com/data/detailed.json"
		case Links = "https://wvusom-data-server.herokuapp.com/data/links.json"
	}
	
}