//
//  UserDefaultsManager.swift
//  WVU Clinical Skills
//
//  Created by Nick on 1/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class UserDefaultsManager {
	
	static let userDefaults = NSUserDefaults.standardUserDefaults()
	
	struct userDefaultsKeys {
		static let requestFromLocalHost = "requestFromLocalHost"
		static let storeLocally = "storeLocally"
	}
	
	static let userDefaultsKeysList = [
		userDefaultsKeys.requestFromLocalHost,
		userDefaultsKeys.storeLocally
	]
	
	static func titleFromKey(key: String) -> String {
		let splitRegex = try! NSRegularExpression(pattern: "([a-z])([A-Z])", options: .AllowCommentsAndWhitespace)
		let splitString = splitRegex.stringByReplacingMatchesInString(key, options: .WithoutAnchoringBounds, range: NSRange(location: 0, length: key.characters.count), withTemplate: "$1 $2")
		return splitString.capitalizedString
	}
	
}