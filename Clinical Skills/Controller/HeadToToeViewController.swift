//
//  HeadToToeViewController.swift
//  Clinical Skills
//
//  Created by Matthew Taylor on 6/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//
import Foundation
import UIKit
import WebKit

class HeadToToeViewController : UIViewController {
    
    // MARK: - Properties
    
    var documentController: UIDocumentInteractionController?
    var dismissing: Bool?
    var webView: UIWebView?
    
    @IBOutlet weak var BackButton: UIButton!
    var url = Bundle.main.url(forResource: "Head To Toe", withExtension: "docx")
    
    @IBOutlet weak var myWebView: UIWebView!
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        if let url = Bundle.main.url(forResource: "Head To Toe", withExtension: "docx") {
            myWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            myWebView.scalesPageToFit = true
            myWebView.frame.origin.y = 30
            myWebView.frame = self.view.bounds
            myWebView.loadRequest(URLRequest(url: url))
            
            
            //view.addSubview(webView)
            
            //self.documentController = UIDocumentInteractionController(url: url)
            //self.documentController!.delegate = self
            //self.dismissing = false
        }
    }

    @IBAction func goBack(_ sender: UIButton) {
        print("i've been clicked");
        myWebView.goBack();
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        webView?.goBack();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.presentPreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismissing = false
    }
    
    // MARK: - Interface Builder Connections
    
    @IBAction func show(_ sender: UIButton) {
        self.dismissing = false
        self.presentPreview()
    }
    
    // MARK: - Navigation Methods
    
    func presentPreview() {
        if let dismissing = self.dismissing, dismissing == false {
            if self.documentController != nil {
                self.documentController!.presentPreview(animated: true)
            }
        }
    }
    
}

// MARK: - Document Interface Controller Delegate Methods

extension HeadToToeViewController : UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        self.dismissing = true
    }
}
