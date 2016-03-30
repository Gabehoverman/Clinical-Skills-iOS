//
//  BasicPhoto.swift
//  Clinical Skills
//
//  Created by Nick on 3/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit
import NYTPhotoViewer

class BasicPhoto : NSObject, NYTPhoto {
	
	var image: UIImage?
	var imageData: NSData?
	var placeholderImage: UIImage?
	let attributedCaptionTitle: NSAttributedString?
	let attributedCaptionSummary: NSAttributedString?
	let attributedCaptionCredit: NSAttributedString?
	
	init(image: UIImage? = nil, imageData: NSData? = nil, captionTitle: NSAttributedString) {
		self.image = image
		self.imageData = imageData
		self.attributedCaptionTitle = captionTitle
		self.attributedCaptionSummary = nil
		self.attributedCaptionCredit = nil
		super.init()
	}
	
}