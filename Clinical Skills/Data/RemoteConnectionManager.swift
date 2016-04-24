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
	
	var baseURL: String {
		get {
			if self.shouldRequestFromLocal {
				return "http://localhost:3000/"
			} else {
				return "https://wvsom-clinical-skills.herokuapp.com/"
			}
		}
	}
	
	struct dataURLs {
		static let personnelAcknowledgement = "personnel_acknowledgements"
		static let softwareAcknowledgement = "software_acknowledgements"
		static let systems = "systems"
		static let examTechnique = "exam_techniques"
		static let components = "components"
		static let palpations = "palpations"
		static let rangesOfMotion = "ranges_of_motion"
		static let muscles = "muscles"
		static let specialTests = "special_tests"
		static let imageLinks = "image_links"
		static let videoLinks = "video_links"
		static let images = "wvsom/image/upload/v1/"
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
	
	init(delegate: RemoteConnectionManagerDelegate?) {
		self.shouldRequestFromLocal = UserDefaultsManager.userDefaults.boolForKey(UserDefaultsManager.userDefaultsKeys.requestFromLocalHost).boolValue
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
	
	func fetchPersonnelAcknowledgements() {
		self.fetchWithQueryString(dataURLs.personnelAcknowledgement, queryString: nil)
	}
	
	func fetchSoftwareAcknowledgements() {
		self.fetchWithQueryString(dataURLs.softwareAcknowledgement, queryString: nil)
	}
	
	func fetchSystems() {
		self.fetchWithQueryString(dataURLs.systems, queryString: nil)
	}
	
	func fetchExamTechniques(forSystem system: System) {
		self.fetchWithQueryString(dataURLs.examTechnique, queryString: "system=\(system.name)")
	}
	
	func fetchComponents(forSystem system: System) {
		self.fetchWithQueryString(dataURLs.components, queryString: "system=\(system.name)")
	}
	
	func fetchPalpations(forComponent component: Component) {
		self.fetchWithQueryString(dataURLs.palpations, queryString: "component=\(component.name)")
	}
	
	func fetchRangesOfMotion(forComponent component: Component) {
		self.fetchWithQueryString(dataURLs.rangesOfMotion, queryString: "component=\(component.name)")
	}
	
	func fetchMuscles(forComponent component: Component) {
		self.fetchWithQueryString(dataURLs.muscles, queryString: "component=\(component.name)")
	}
	
	func fetchSpecialTests(forComponent component: Component) {
		self.fetchWithQueryString(dataURLs.specialTests, queryString: "component=\(component.name)")
	}
	
	func fetchImageLinks(forSpecialTest specialTest: SpecialTest) {
		self.fetchWithQueryString(dataURLs.imageLinks, queryString: "special_test=\(specialTest.name)")
	}
	
	func fetchVideoLinks(forSpecialTest specialTest: SpecialTest) {
		self.fetchWithQueryString(dataURLs.videoLinks, queryString: "special_test=\(specialTest.name)")
	}
	
	func fetchVideoLinks(forExamTechnique examTechnique: ExamTechnique) {
		self.fetchWithQueryString(dataURLs.videoLinks, queryString: "exam_technique=\(examTechnique.name)")
	}
	
	func fetchImageData(forCloudinaryLink cloudinaryLink: String) {
		self.fetchWithCloudinaryLink(cloudinaryLink)
	}
	
	private func fetchWithQueryString(urlRoute: String, queryString: String?) {
		var urlString = self.baseURL + urlRoute + "?"
		if (queryString != nil) {
			urlString += queryString! + "&"
		}
		urlString += "format=json"
		if (urlString.characters.last == "?" || urlString.characters.last == "&") {
			urlString = String(urlString.characters.dropLast())
		}
		urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		if let url = NSURL(string: urlString) {
			print("Fetching with URL \(url.absoluteString)")
			let session = NSURLSession.sharedSession()
			session.dataTaskWithURL(url, completionHandler: {
				(receivedData: NSData?, httpResponse: NSURLResponse?, error: NSError?) -> Void in
				self.completedDataRequestWithData(false, data: receivedData, response: httpResponse, error: error)
			}).resume()
			self.delegate?.didBeginDataRequest?()
		}
	}
	
	private func fetchWithCloudinaryLink(cloudinaryLink: String) {
		if let url = NSURL(string: cloudinaryLink) {
			print("Fetching with URL \(url.absoluteString)")
			let session = NSURLSession.sharedSession()
			session.dataTaskWithURL(url, completionHandler: { (receivedData: NSData?, httpResponse: NSURLResponse?, error: NSError?) in
				self.completedDataRequestWithData(true, data: receivedData, response: httpResponse, error: error)
			}).resume()
			self.delegate?.didBeginDataRequest?()
		}
	}
	
	// MARK: - Completion Methods
	
	private func completedDataRequestWithData(isCloudinaryFetch: Bool, data: NSData?, response: NSURLResponse?, error: NSError?) {
		if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
			self.statusCode = statusCode
		} else {
			self.statusCode = 0
		}
		
		if error != nil {
			print("Error Fetching Remote Data\n")
			self.delegate?.didFinishDataRequestWithError?(error!)
		}
		
		if data != nil {
			if isCloudinaryFetch {
				self.delegate?.didFinishCloudinaryImageRequestWithData?(data!)
			} else {
				self.delegate?.didFinishDataRequestWithData?(data!)
			}
		}
		self.delegate?.didFinishDataRequest?()
	}
	
	// MARK: - Error Handling Methods
	
	func messageForError(error: NSError) -> String {
		return "Error Fetching Remote Data" + "\n" + "\(error.localizedDescription)"
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