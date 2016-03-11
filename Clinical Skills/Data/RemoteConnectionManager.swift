//
//  RemoteConnectionManager.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/26/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation

@objc protocol RemoteConnectionManagerDelegate {
	optional func didBeginDataRequest()
	optional func didFinishDataRequest()
	optional func didFinishDataRequestWithData(receivedData: NSData)
	optional func didFinishDataRequestWithError(error: NSError)
}

class RemoteConnectionManager : NSObject {
	
	let localBaseURL = "http://localhost:3000/"
	let remoteBaseURL = "https://clinical-skills-data-server.herokuapp.com/"
	
	struct dataURLs {
		static let systems = "systems.json"
		static let components = "components.json"
		static let specialTests = "special_tests.json"
		static let videoLinks = "video_links.json"
	}
	
	// MARK: - Properties

	var shouldRequestFromLocal: Bool
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
	
	init(shouldRequestFromLocal: Bool, delegate: RemoteConnectionManagerDelegate?) {
		self.shouldRequestFromLocal = shouldRequestFromLocal
		self.statusCode = 0
		self.delegate = delegate
	}
	
	// MARK: - Fetch Methods
	
	func fetchSystems() {
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
	
	func fetchComponents(forSystem: System) {
		var urlString: String
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.components
		
		var queryString = "?system=" + forSystem.name
		queryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		urlString += queryString
		
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	func fetchSpecialTests(forComponent: Component) {
		var urlString: String
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.specialTests
		
		var queryString = "?component=" + forComponent.name
		queryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		urlString += queryString
		
		if let url = NSURL(string: urlString) {
			self.fetchWithURL(url)
		}
	}
	
	func fetchVideoLinks(forSpecialTest: SpecialTest) {
		var urlString: String
		if self.shouldRequestFromLocal {
			urlString = self.localBaseURL
		} else {
			urlString = self.remoteBaseURL
		}
		
		urlString += dataURLs.videoLinks
		
		var queryString = "?special_test=" + forSpecialTest.name
		queryString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		urlString += queryString
		
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
	
	// MARK: - Utility Methods
	
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
			self.delegate?.didFinishDataRequestWithData?(data!)
		}
		self.delegate?.didFinishDataRequest?()
	}
	
	func messageForError(error: NSError) -> String {
		return "RemoteConnectionManager - Error fetching remote data" + "\n" + "\(error.localizedDescription)"
	}
	
}