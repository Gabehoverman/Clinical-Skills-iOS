//
//  VideoViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/18/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

	var videoLink: String?
	
    @IBOutlet weak var videoWebView: UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let link = self.videoLink {
			if let url = NSURL(string: link) {
				self.videoWebView.loadRequest(NSURLRequest(URL: url))
			}
		}
	}
	
	@IBAction func closeButtonPressed(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}