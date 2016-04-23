//
//  SoftwareWebsiteViewController.swift
//  Clinical Skills
//
//  Created by Nick on 4/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

class SoftwareWebsiteViewController : UIViewController {
	
	@IBOutlet weak var webView: UIWebView!
	
	var link: String?
	
	override func viewDidLoad() {
		if self.link != nil {
			if let url = NSURL(string: self.link!) {
				let request = NSURLRequest(URL: url)
				self.webView.loadRequest(request)
			}
		}
	}
	
}