//
//  VideoViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/18/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController, UIWebViewDelegate {

	var videoLink: String?
	
    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.videoWebView.delegate = self
		self.activityIndicator.hidesWhenStopped = true
		if let link = self.videoLink {
			if let url = NSURL(string: link) {
				self.videoWebView.loadRequest(NSURLRequest(URL: url))
			}
		}
	}
	
	@IBAction func closeButtonPressed(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		self.activityIndicator.startAnimating()
		return true
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = false
		self.activityIndicator.stopAnimating()
	}
	
	func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = false
		self.activityIndicator.stopAnimating()
	}
}