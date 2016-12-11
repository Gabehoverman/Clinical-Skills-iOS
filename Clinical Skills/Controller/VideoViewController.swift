//
//  VideoViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/6/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class VideoViewController : UIViewController {
	
	// MARK: - Properties
	
	@IBOutlet weak var webView: UIWebView!
	
	var videoLink: VideoLink?
	
	// MARK: - View Controller Methods
	
	override func viewDidLoad() {
		if self.videoLink != nil {
			if let url = URL(string: self.videoLink!.link) {
				let request = URLRequest(url: url)
				self.webView.loadRequest(request)
			}
		}
	}
	
}
