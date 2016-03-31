//
//  StoryboardIdentifiers.swift
//  Clinical Skills
//
//  Created by Nick on 3/31/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

struct StoryboardIdentifiers {
	struct segue {
		static let toComponentsView = "toComponentsView"
		static let toComponentDetailsView = "toComponentDetailsView"
		static let toExamsView = "toExamsView"
		static let toSpecialTestsView = "toSpecialTestsView"
		static let toSpecialTestsDetailView = "toSpecialTestsDetailView"
	}
	
	struct tab {
		static let clinicalSkills = "Clinical Skills"
		static let pocketHistory = "Pocket History"
		static let outlinedReview = "Outlined Review"
	}
	
	struct controller {
		static let specialTestsTableViewController = "SpecialTestsTableViewController"
		static let basicExamsTableViewController = "BasicExamsTableViewController"
	}
}