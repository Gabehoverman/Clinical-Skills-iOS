//
//  ComponentFileController.swift
//  Clinical Skills
//
//  Created by Matthew Taylor on 3/1/17.
//  Copyright © 2017 Nick. All rights reserved.
//


import UIKit
import WebKit

class ComponentFileController : UIViewController {
    
    // MARK: - Properties
    
    var documentController: UIDocumentInteractionController?
    var webView: UIWebView?
    var dismissing: Bool?
    var system: System?
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        
        /* Determine which system the previous segue is coming from */
        
        let selectedSystem = self.system?.name;
        var systemFileName = " ";
        
        
         
        switch(selectedSystem){
        case "Abdomen"?:
            systemFileName = "Abdomen System";
        case "Cardiovascular"?:
            systemFileName = "Cardiovascular System";
        case "Eye"?:
            systemFileName = "Eye System";
        case "Head, Ears, Nose, Neck, Throat"?:
            systemFileName = "HENNT System";
        case "Musculoskeletal"?:
            systemFileName = "Musculoskeletal System";
        case "Neurological"?:
            systemFileName = "Neurological System";
        case "Respiratory"?:
            systemFileName = "Respiratory System";
        case "Vital Signs"?:
            systemFileName = "Vital Signs";
        default:
            systemFileName = " "
        }
        
        /* Fetch the corresponding system document */
        /* If the document is Musculoskeletal, load the pdf because of weird image bugs in the docx */
        
        if selectedSystem != "Musculoskeletal"{
            if let url = Bundle.main.url(forResource: systemFileName, withExtension: "docx") {
                let webView = UIWebView(frame: self.view.frame)
                webView.loadRequest(URLRequest(url: url))
                webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                webView.scalesPageToFit = true
                webView.frame.origin.y = 50
                view.addSubview(webView)
            
                //self.documentController = UIDocumentInteractionController(url: url)
                //self.documentController!.delegate = self
                //self.dismissing = false
            }
        }
        else {
            if let url = Bundle.main.url(forResource: systemFileName, withExtension: "pdf") {
                let webView = UIWebView(frame: self.view.frame)
                webView.loadRequest(URLRequest(url: url))
                webView.frame.origin.y = 50
                view.addSubview(webView)
                
                //self.documentController = UIDocumentInteractionController(url: url)
                //self.documentController!.delegate = self
                //self.dismissing = false
            }
        }
        
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

extension ComponentFileController : UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        self.dismissing = true
    }
}
