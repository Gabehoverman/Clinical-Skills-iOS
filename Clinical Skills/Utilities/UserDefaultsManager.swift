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
	}
	
	static let userDefaultsKeysList = [
		userDefaultsKeys.requestFromLocalHost,
	]
	
	static func titleFromKey(key: String) -> String {
		let splitRegex = try! NSRegularExpression(pattern: "([a-z])([A-Z])", options: .AllowCommentsAndWhitespace)
		let splitString = splitRegex.stringByReplacingMatchesInString(key, options: .WithoutAnchoringBounds, range: NSRange(location: 0, length: key.characters.count), withTemplate: "$1 $2")
		return splitString.capitalizedString
	}
	
	static func readFromSettingsBundle() {
		if let settingsBundle = NSBundle.mainBundle().pathForResource("Settings", ofType: "bundle") {
			if let settings = NSDictionary(contentsOfFile: NSString(string: settingsBundle).stringByAppendingPathComponent("Root.plist")) {
				if let preferences: [NSDictionary] = settings.objectForKey("PreferenceSpecifiers") as? [NSDictionary] {
					var defaultsToRegister = [String : AnyObject]()
					for preferenceSpecifier in preferences {
						if let key = preferenceSpecifier.objectForKey("Key") as? String {
							defaultsToRegister[key] = preferenceSpecifier.objectForKey("DefaultValue")!
						}
					}
					print(defaultsToRegister)
					NSUserDefaults.standardUserDefaults().registerDefaults(defaultsToRegister)
				} else {
					print("Error reading Preferences")
				}
			} else {
				print("Error reading Root.plist")
			}
		} else {
			print("Error reading Settings.bundle")
		}
	}
	
	static func printUserDefaults() {
		for key in userDefaultsKeysList {
			if let value = userDefaults.objectForKey(key) {
				print("\(key) -> \(value)")
			}
		}
	}
	
}