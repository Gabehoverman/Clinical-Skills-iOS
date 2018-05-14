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
                //return "http://localhost:3000/"
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
			return "Status Code \(statusCode): \(HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)"
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
		self.shouldRequestFromLocal = UserDefaultsManager.userDefaults.bool(forKey: UserDefaultsManager.userDefaultsKeys.requestFromLocalHost)
		self.statusCode = 0
		self.delegate = delegate
		super.init()
		NotificationCenter.default.addObserver(self, selector: #selector(self.setShouldRequestFromLocal), name: UserDefaults.didChangeNotification, object: nil)
	}
	
	// MARK: - Deinitializers
	
	deinit {
		NotificationCenter.default.removeObserver(self)
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
    
    func fetchSystemVideoLinks(forSystem system: System) {
        self.fetchWithQueryString(dataURLs.videoLinks, queryString: "system=\(system.name.lowercased())")
    }
	
	func fetchImageData(forCloudinaryLink cloudinaryLink: String) {
		self.fetchWithCloudinaryLink(cloudinaryLink)
	}
	
	fileprivate func fetchWithQueryString(_ urlRoute: String, queryString: String?) {
		var urlString = self.baseURL + urlRoute + "?"
		if (queryString != nil) {
			urlString += queryString! + "&"
		}
		urlString += "format=json"
		if (urlString.characters.last == "?" || urlString.characters.last == "&") {
			urlString = String(urlString.characters.dropLast())
		}
		urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
		if let url = URL(string: urlString) {
			print("Fetching with URL \(url.absoluteString)")
			let session = URLSession.shared

            session.dataTask(with: url, completionHandler: { (data, response, error) in
                self.completedDataRequestWithData(false, data: data, response: response, error: error as NSError?)
            }).resume()
            
			self.delegate?.didBeginDataRequest?()
		}
	}
	
	fileprivate func fetchWithCloudinaryLink(_ cloudinaryLink: String) {
		if let url = URL(string: cloudinaryLink) {
			print("Fetching with URL \(url.absoluteString)")
			let session = URLSession.shared
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                self.completedDataRequestWithData(true, data: data, response: response, error: error as NSError?)
            }).resume()
            
			self.delegate?.didBeginDataRequest?()
		}
	}
	
	// MARK: - Completion Methods
	
	fileprivate func completedDataRequestWithData(_ isCloudinaryFetch: Bool, data: Data?, response: URLResponse?, error: NSError?) {
		if let statusCode = (response as? HTTPURLResponse)?.statusCode {
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
	
	func messageForError(_ error: NSError) -> String {
		return "Error Fetching Remote Data" + "\n" + "\(error.localizedDescription)"
	}
	
	// MARK: - Notification Center Observer Methods
	
	func setShouldRequestFromLocal() {
		self.shouldRequestFromLocal = UserDefaultsManager.userDefaults.bool(forKey: UserDefaultsManager.userDefaultsKeys.requestFromLocalHost)
	}
	
}

// MARK: - Remote Connection Manager Protocol

@objc protocol RemoteConnectionManagerDelegate {
	@objc optional func didBeginDataRequest()
	@objc optional func didFinishDataRequest()
	@objc optional func didFinishDataRequestWithData(_ receivedData: Data)
	@objc optional func didFinishCloudinaryImageRequestWithData(_ receivedData: Data)
	@objc optional func didFinishDataRequestWithError(_ error: NSError)
}
