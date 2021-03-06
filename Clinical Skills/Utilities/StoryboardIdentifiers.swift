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
		static let toSystemBreakdownView = "ToSystemBreakdownView"
		static let toExamTechniquesView = "ToExamTechniquesView"
		static let toExamTechniquesDetailsView = "ToExamTechniquesDetailsView"
		static let toComponentsView = "ToComponentsView"
		static let toComponentDetailsView = "ToComponentDetailsView"
		static let toSpecialTestsView = "ToSpecialTestsView"
		static let toSpecialTestsDetailView = "ToSpecialTestsDetailView"
		static let toVideoView = "ToVideoView"
		static let toPersonnelAcknowledgementsView = "ToPersonnelAcknowledgementsView"
		static let toSoftwareAcknowledgementsView = "ToSoftwareAcknowledgementsView"
		static let toSoftwareWebsiteView = "ToSoftwareWebsiteView"
        static let toDisclaimerView = "ToDisclaimerView"
        //static let toPocketHistory = "ToPocketHistoryView"
        static let toComponentFile = "ToComponentFile"
	}
	
	struct tab {
		static let clinicalSkills = 0
		static let pocketHistory = 1
		static let outlinedReview = 2
	}
	
	struct controller {
		static let componentsTableViewController = "ComponentsTableViewController"
		static let examTechniquesTableViewController = "ExamTechniquesTableViewController"
		static let personnelAcknowledgementTableViewController = "PersonnelAcknowledgementTableViewController"
		static let softwareAcknowledgementTableViewController = "SoftwareAcknowledgementTableViewController"
        static let disclaimerViewController = "DisclaimerViewController"
        static let componentFileController = "ComponentFileController"
	}
	
	struct cell {
		static let systemCell = "SystemCell"
		
		static let componentCell = "ComponentCell"
		static let componentInspectionCell = "ComponentInspectionCell"
		static let componentPalpationCell = "ComponentPalpationCell"
		static let componentRangeOfMotionCell = "ComponentRangeOfMotionCell"
		static let componentSpecialTestsCell = "ComponentSpecialTestsCell"
		
		static let examTechniqueCell = "ExamTechniqueCell"
		static let examTechniqueNameCell = "ExamTechniqueNameCell"
		static let examTechniqueDetailsCell = "ExamTechniqueDetailsCell"
		static let examTechniqueVideoLinkCell = "ExamTechniqueVideoLinkCell"
		
		static let specialTestCell = "SpecialTestCell"
		static let specialTestNameCell = "SpecialTestNameCell"
		static let specialTestPositiveSignCell = "SpecialTestPositiveSignCell"
		static let specialTestIndicationCell = "SpecialTestIndicationCell"
		static let specialTestNoteCell = "SpecialTestNoteCell"
		static let specialTestImagesCell = "SpecialTestImagesCell"
		static let specialTestVideoLinkCell = "SpecialTestVideoLinkCell"
		static let collectionImageCell = "CollectionImageCell"
		
		static let personnelAcknowledgementCell = "PersonnelAcknowledgementCell"
		static let softwareAcknowledgementCell = "SoftwareAcknowledgementCell"
	}
}
