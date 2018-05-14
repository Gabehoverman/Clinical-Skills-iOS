//
//  PDFReviewViewController.swift
//  Clinical Skills
//
//  Created by Gabriel Hoverman on 8/29/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit

class PDFReviewViewController: UIViewController {
    
    var documentController: UIDocumentInteractionController?
    var webView: UIWebView?
    var dismissing: Bool?
    var system: System?
    var data: System?
    
    override func viewDidLoad() {
        
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
    
        if selectedSystem != "Musculoskeletal"{
            if let url = Bundle.main.url(forResource: systemFileName, withExtension: "docx") {
                let webView = UIWebView(frame: self.view.frame)
                webView.loadRequest(URLRequest(url: url))
                webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                webView.scalesPageToFit = true
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
}

