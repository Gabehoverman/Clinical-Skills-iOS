//
//  SystemDetailViewController.swift
//  WVU Clinical Skills
//
//  Created by Nick Alexander on 12/15/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import UIKit

class SystemDetailViewController: UIViewController {

	var system: System?
	
	@IBOutlet weak var descriptionTextView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if self.system != nil {
			self.descriptionTextView.text = self.system!.systemDescription
		}
    }

}