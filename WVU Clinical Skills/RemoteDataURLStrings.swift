//
//  RemoteUrls.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

class RemoteDataURLStrings {
	
	private static let base = "https://wvusom-data-server.herokuapp.com/data/"
	private static let ext = ".json"
	
	static let systems = base + "systems" + ext
	static let subsystems = base + "subsystems" + ext
	static let detailed = base + "detailed" + ext
	static let links = base + "links" + ext
	
}