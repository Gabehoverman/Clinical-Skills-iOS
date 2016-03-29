//
//  RemoteConnectionManager.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

class RemoteConnectionManager : NSObject {
	
	// MARK: - URL Constants
	
	let localBaseURL = "http://localhost:3000/"
	let remoteImageURL = "http://res.cloudinary.com/"
	let remoteBaseURL = "https://clinical-skills-data-server.herokuapp.com/"
	
	struct dataURLs {
		static let systems = "systems.json"
		static let components = "components.json"
		static let ranges_of_motion = "ranges_of_motion.json"
		static let specialTests = "special_tests.json"
		static let imageLinks = "image_links.json"
		static let videoLinks = "video_links.json"
		static let images = "wvsom/image/upload/v1/"
	}
	
	// MARK: - Properties
	
	var shouldRequestFromLocal: Bool
	var isCloudinaryFetch: Bool
	var statusCode: Int
	var statusMessage: String {
		get {
			if self.statusCode == 0 {
				return "No Response"
			}
			return "Status Code \(statusCode): \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode).capitalizedString)"
		}
	}
	var statusSuccess: Bool {
		get {
			return self.statusCode >= 200 && self.statusCode < 300
		}
	}
	
	var delegate: RemoteConnectionManagerDelegate?
	
	// MARK: - Initializers
	
	init(delegate: RemoteConnectionManagerDelegate?) {
		self.shouldRequestFromLocal = UserDefaultsManager.userDefaults.boolForKey(UserDefaultsManager.userDefaultsKeys.requestFromLocalHost).boolValue
		self.isCloudinaryFetch = false
		self.statusCode = 0
		self.delegate = delegate
		super.init()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setShouldRequestFromLocal), name: NSUserDefaultsDidChangeNotification, object: nil)
	}
	
	// MARK: - Deinitializers
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	// MARK: - Fetch Methods
	
	func fetchSystems() {
		self.isCloudinaryFetch = false
		
		var urlString: String
		
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.systems
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	func fetchComponents(forSystem system: System) {
		self.isCloudinaryFetch = false
		
		var urlString: String
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.components
		
		var queryString = "?system=\(system.name)"
		queryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		urlString += queryString
		
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	func fetchRangesOfMotion(forComponent component: Component) {
		self.isCloudinaryFetch = false
		
		var urlString: String
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.ranges_of_motion
		
		var queryString = "?component=\(component.name)"
		queryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		urlString += queryString
		
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	func fetchSpecialTests(forComponent component: Component) {
		self.isCloudinaryFetch = false
		
		var urlString: String
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.specialTests
		
		var queryString = "?component=\(component.name)"
		queryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		urlString += queryString
		
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	func fetchImageLinks(forSpecialTest specialTest: SpecialTest) {
		self.isCloudinaryFetch = false
		
		var urlString: String
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.imageLinks
		
		var queryString = "?special_test=\(specialTest.name)"
		queryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		urlString += queryString
		
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	func fetchVideoLinks(forSpecialTest specialTest: SpecialTest) {
		self.isCloudinaryFetch = false
		
		var urlString: String
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.videoLinks
		
		var queryString = "?special_test=\(specialTest.name)"
		queryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		urlString += queryString
		
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	func fetchImageData(forCloudinaryLink cloudinaryLink: String) {
		self.isCloudinaryFetch = true
		
		let urlString = cloudinaryLink
		
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	private func fetchWithURL(url: NSURL) {
		print("Fetching with URL \(url.absoluteString)")
		let session = NSURLSession.sharedSession()
		session.dataTaskWithURL(url, completionHandler: {
			(receivedData: NSData?, httpResponse: NSURLResponse?, error: NSError?) -> Void in
				self.completedDataTaskReceivingData(receivedData, response: httpResponse, error: error)
		}).resume()
		self.delegate?.didBeginDataRequest?()
	}
	
	// MARK: - Completion Methods
	
	private func completedDataTaskReceivingData(data: NSData?, response: NSURLResponse?, error: NSError?) {
		if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
			self.statusCode = statusCode
		} else {
			self.statusCode = 0
		}
		
		if error != nil {
			print(self.messageForError(error!))
			self.delegate?.didFinishDataRequestWithError?(error!)
		}
		
		if data != nil {
			if self.isCloudinaryFetch {
				self.delegate?.didFinishCloudinaryImageRequestWithData?(data!)
			} else {
				self.delegate?.didFinishDataRequestWithData?(data!)
			}
		}
		self.delegate?.didFinishDataRequest?()
	}
	
	// MARK: - Error Handling Methods
	
	func messageForError(error: NSError) -> String {
		return "RemoteConnectionManager - Error fetching remote data" + "\n" + "\(error.localizedDescription)"
	}
	
	// MARK: - Notification Center Observer Methods
	
	func setShouldRequestFromLocal() {
		self.shouldRequestFromLocal = UserDefaultsManager.userDefaults.boolForKey(UserDefaultsManager.userDefaultsKeys.requestFromLocalHost).boolValue
	}
	
}

// MARK: - Remote Connection Manager Protocol

@objc protocol RemoteConnectionManagerDelegate {
	optional func didBeginDataRequest()
	optional func didFinishDataRequest()
	optional func didFinishDataRequestWithData(receivedData: NSData)
	optional func didFinishCloudinaryImageRequestWithData(receivedData: NSData)
	optional func didFinishDataRequestWithError(error: NSError)
}