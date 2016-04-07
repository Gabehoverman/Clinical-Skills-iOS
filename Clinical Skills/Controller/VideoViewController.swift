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
	
	@IBOutlet weak var webView: UIWebView!
	
	var videoLink: VideoLink?
	
	override func viewDidLoad() {
		if self.videoLink != nil {
			if let url = NSURL(string: self.videoLink!.link) {
				let request = NSURLRequest(URL: url)
				self.webView.loadRequest(request)
			}
		}
	}
	
}