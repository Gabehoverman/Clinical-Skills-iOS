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
			} else if self.isCloudinaryFetch {
				return "https://res.cloudinary.com/"
			} else {
				return "https://wvsom-clinical-skills.herokuapp.com/"
			}
		}
	}
	
	struct dataURLs {
		static let personnelAcknowledgement = "personnel_acknowledgements.json"
		static let softwareAcknowledgement = "software_acknowledgements.json"
		static let systems = "systems.json"
		static let examTechnique = "exam_techniques.json"
		static let components = "components.json"
		static let palpations = "palpations.json"
		static let rangesOfMotion = "ranges_of_motion.json"
		static let muscles = "muscles.json"
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
	
	func fetchPersonnelAcknowledgements() {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.personnelAcknowledgement)
	}
	
	func fetchSoftwareAcknowledgements() {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.softwareAcknowledgement)
	}
	
	func fetchSystems() {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.systems)
	}
	
	func fetchExamTechniques(forSystem system: System) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.examTechnique + "?system=\(system.name)")
	}
	
	func fetchComponents(forSystem system: System) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.components + "?system=\(system.name)")
	}
	
	func fetchPalpations(forComponent component: Component) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.palpations + "?component=\(component.name)")
	}
	
	func fetchRangesOfMotion(forComponent component: Component) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.rangesOfMotion + "?component=\(component.name)")
	}
	
	func fetchMuscles(forComponent component: Component) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.muscles + "?component=\(component.name)")
	}
	
	func fetchSpecialTests(forComponent component: Component) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.specialTests + "?component=\(component.name)")
	}
	
	func fetchImageLinks(forSpecialTest specialTest: SpecialTest) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.imageLinks + "?special_test=\(specialTest.name)")
	}
	
	func fetchVideoLinks(forSpecialTest specialTest: SpecialTest) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.videoLinks + "?special_test=\(specialTest.name)")
	}
	
	func fetchVideoLinks(forExamTechnique examTechnique: ExamTechnique) {
		self.isCloudinaryFetch = false
		self.fetchWithQueryString(dataURLs.videoLinks + "?exam_technique=\(examTechnique.name)")
	}
	
	func fetchImageData(forCloudinaryLink cloudinaryLink: String) {
		self.isCloudinaryFetch = true
		self.fetchWithQueryString(cloudinaryLink)
	}
	
	private func fetchWithQueryString(queryString: String) {
		var urlString = self.baseURL
		urlString += queryString
		urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		if let url = NSURL(string: urlString) {
			print("Fetching with URL \(url.absoluteString)")
			let session = NSURLSession.sharedSession()
			session.dataTaskWithURL(url, completionHandler: {
				(receivedData: NSData?, httpResponse: NSURLResponse?, error: NSError?) -> Void in
				self.completedDataTaskReceivingData(receivedData, response: httpResponse, error: error)
			}).resume()
			self.delegate?.didBeginDataRequest?()
		}
	}
	
	// MARK: - Completion Methods
	
	private func completedDataTaskReceivingData(data: NSData?, response: NSURLResponse?, error: NSError?) {
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