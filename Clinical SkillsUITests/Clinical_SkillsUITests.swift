//
//  Clinical_SkillsUITests.swift
//  Clinical SkillsUITests
//
//  Created by Nick on 4/14/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import XCTest

class Clinical_SkillsUITests: XCTestCase { 
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testComponentDetails() {
		
		let app = XCUIApplication()
		let tablesQuery = app.tables
		tablesQuery.staticTexts["Musculoskeletal"].tap()
		tablesQuery.staticTexts["Cervical Spine"].tap()
		
		let componentsButton = app.navigationBars["Details"].buttons["Components"]
		componentsButton.tap()
		tablesQuery.staticTexts["Lumbar Spine"].tap()
		componentsButton.tap()
		tablesQuery.staticTexts["Shoulder"].tap()
		componentsButton.tap()
		tablesQuery.staticTexts["Elbow"].tap()
		componentsButton.tap()
		tablesQuery.staticTexts["Wrist and Hand"].tap()
		componentsButton.tap()
		tablesQuery.staticTexts["Hip"].tap()
		componentsButton.tap()
		tablesQuery.staticTexts["Ankle/Foot"].tap()
		componentsButton.tap()
		
		let systemsButton = app.navigationBars["Components"].buttons["Systems"]
		systemsButton.tap()
		tablesQuery.staticTexts["Eye"].tap()
		systemsButton.tap()
		
		let cardiovascularStaticText = tablesQuery.staticTexts["Cardiovascular"]
		cardiovascularStaticText.tap()
		cardiovascularStaticText.tap()
		componentsButton.tap()
		systemsButton.tap()
		tablesQuery.staticTexts["Head, Ear, Eyes, Nose, Throat"].tap()
		systemsButton.tap()
		
		let respiratoryStaticText = tablesQuery.staticTexts["Respiratory"]
		respiratoryStaticText.tap()
		respiratoryStaticText.tap()
		componentsButton.tap()
		systemsButton.tap()
		
		let neurologicalStaticText = tablesQuery.staticTexts["Neurological"]
		neurologicalStaticText.tap()
		neurologicalStaticText.tap()
		componentsButton.tap()
		systemsButton.tap()
		
		let abdomenStaticText = tablesQuery.staticTexts["Abdomen"]
		abdomenStaticText.tap()
		abdomenStaticText.tap()
		componentsButton.tap()
		systemsButton.tap()
		
	}
	
	func testSpecialTests() {
		
		let app = XCUIApplication()
		app.tabBars.buttons["Outlined Review"].tap()
		
		let tablesQuery = app.tables
		tablesQuery.staticTexts["Musculoskeletal"].tap()
		tablesQuery.staticTexts["Cervical Spine"].tap()
		tablesQuery.staticTexts["Spurling's Test"].tap()
		
		let specialTestDetailsNavigationBar = app.navigationBars["Special Test Details"]
		let specialTestsButton = specialTestDetailsNavigationBar.buttons["Special Tests"]
		specialTestsButton.tap()
		tablesQuery.staticTexts["Compression and Distraction Tests"].tap()
		specialTestsButton.tap()
		
		let systemBreakdownButton = app.navigationBars["Special Tests"].buttons["System Breakdown"]
		systemBreakdownButton.tap()
		tablesQuery.staticTexts["Lumbar Spine"].tap()
		tablesQuery.staticTexts["Straight Leg Raising Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Femoral Stretch Test"].tap()
		specialTestsButton.tap()
		systemBreakdownButton.tap()
		tablesQuery.staticTexts["Shoulder"].tap()
		tablesQuery.staticTexts["Apley Scratch Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Yergason Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Drop Arm Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Neer Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Hawkins-Kennedy Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Supraspinatus Test/Empty Can Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Apprehension Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Jerk Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Sulcus Test"].tap()
		specialTestsButton.tap()
		systemBreakdownButton.tap()
		tablesQuery.staticTexts["Elbow"].tap()
		tablesQuery.staticTexts["Ligamentous Stability Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Tinel's Sign"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Tennis Elbow Test/Cozen's Sign"].tap()
		specialTestsButton.tap()
		systemBreakdownButton.tap()
		tablesQuery.staticTexts["Wrist and Hand"].tap()
		tablesQuery.staticTexts["Flexor Digitorum Superficialis"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Flexor Digitorum Profundus"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Allen Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Phalen's Test"].tap()
		specialTestsButton.tap()
		systemBreakdownButton.tap()
		tablesQuery.staticTexts["Hip"].tap()
		tablesQuery.staticTexts["Trendelenburg Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Thomas Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Patrick Test/FABER Test"].tap()
		specialTestsButton.tap()
		systemBreakdownButton.tap()
		tablesQuery.staticTexts["Ankle/Foot"].tap()
		tablesQuery.staticTexts["Thompson-Doherty Squeeze Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Ankle Drawer Sign Test"].tap()
		specialTestsButton.tap()
		systemBreakdownButton.tap()
		
		let systemBreakdownNavigationBar = app.navigationBars["System Breakdown"]
		let systemsButton = systemBreakdownNavigationBar.buttons["Systems"]
		systemsButton.tap()
		tablesQuery.staticTexts["Eye"].tap()
		systemBreakdownNavigationBar.tap()
		
		let cardiovascularStaticText = tablesQuery.staticTexts["Cardiovascular"]
		cardiovascularStaticText.tap()
		cardiovascularStaticText.tap()
		tablesQuery.staticTexts["Homan's Sign Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Capillary Refill"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Pitting Edema"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Bancroft/Moses' Sign Test"].tap()
		specialTestsButton.tap()
		systemBreakdownButton.tap()
		systemBreakdownNavigationBar.tap()
		tablesQuery.staticTexts["Head, Ear, Eyes, Nose, Throat"].tap()
		systemBreakdownNavigationBar.tap()
		
		let respiratoryStaticText = tablesQuery.staticTexts["Respiratory"]
		respiratoryStaticText.tap()
		respiratoryStaticText.tap()
		tablesQuery.staticTexts["Chest Excursion"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Crepitus Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Pleural Friction Rub Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Tactile Fremitus Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Bronchophony Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Whispered Pectoriloquy Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Egophony Test"].tap()
		specialTestsButton.tap()
		systemBreakdownButton.tap()
		systemsButton.tap()
		
		let neurologicalStaticText = tablesQuery.staticTexts["Neurological"]
		neurologicalStaticText.tap()
		neurologicalStaticText.tap()
		tablesQuery.staticTexts["Brudzinski Sign Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Kernig Sign Test"].tap()
		specialTestDetailsNavigationBar.tap()
		systemBreakdownButton.tap()
		systemsButton.tap()
		
		let abdomenStaticText = tablesQuery.staticTexts["Abdomen"]
		abdomenStaticText.tap()
		abdomenStaticText.tap()
		tablesQuery.staticTexts["Murphy's Sign"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Shifting Dullness Test"].tap()
		specialTestDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Fluid Wave Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Rebound Tenderness Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Iliopsoas Muscle Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Obturator Muscle Test"].tap()
		specialTestDetailsNavigationBar.tap()
		
		let aaronSSignTestStaticText = tablesQuery.staticTexts["Aaron’s Sign Test"]
		aaronSSignTestStaticText.tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Ballance’s Sign Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Cullen’s Sign Test"].tap()
		specialTestsButton.tap()
		
		let danceSSignTestStaticText = tablesQuery.staticTexts["Dance’s Sign Test"]
		danceSSignTestStaticText.tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Grey Turner’s Sign Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Kehr’s Sign Test"].tap()
		specialTestsButton.tap()
		danceSSignTestStaticText.swipeUp()
		aaronSSignTestStaticText.tap()
		tablesQuery.staticTexts["McBurney’s Point Test"].tap()
		specialTestDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Markle’s Sign Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Rovsing’s Sign Test"].tap()
		specialTestsButton.tap()
		tablesQuery.staticTexts["Howship-Romberg Sign Test"].tap()
		specialTestsButton.tap()
		
	}
	
	func testExamTechniques() {
		
		let app = XCUIApplication()
		app.tabBars.buttons["Outlined Review"].tap()
		
		let tablesQuery = app.tables
		tablesQuery.staticTexts["Musculoskeletal"].tap()
		
		let examTechniquesButton = app.buttons["Exam Techniques"]
		examTechniquesButton.tap()
		
		let element = app.statusBars.childrenMatchingType(.Other).elementBoundByIndex(1)
		element.childrenMatchingType(.Other).elementBoundByIndex(1).tap()
		tablesQuery.staticTexts["Eye"].tap()
		examTechniquesButton.tap()
		tablesQuery.staticTexts["Far Visual Acuity"].tap()
		
		let examTechniqueDetailsNavigationBar = app.navigationBars["Exam Technique Details"]
		let backButton = examTechniqueDetailsNavigationBar.childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0)
		backButton.tap()
		tablesQuery.staticTexts["Near Visual Acuity"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Confrontation Test"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Amsler Grid"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Color Plates"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Corneal Clarity"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Corneal Reflex"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Pupillary Light Reflex"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Accommodation"].tap()
		backButton.tap()
		
		let swingingFlashlightTestStaticText = tablesQuery.staticTexts["Swinging Flashlight Test"]
		swingingFlashlightTestStaticText.tap()
		backButton.tap()
		tablesQuery.staticTexts["Extraocular Muscle Movements"].tap()
		backButton.tap()
		swingingFlashlightTestStaticText.swipeUp()
		tablesQuery.staticTexts["Corneal Light Reflex"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Cover-Uncover Test"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Ophthalmoscopic Exam"].tap()
		backButton.tap()
		
		let systemsButton = app.navigationBars["System Breakdown"].buttons["Systems"]
		systemsButton.tap()
		tablesQuery.staticTexts["Cardiovascular"].tap()
		examTechniquesButton.tap()
		tablesQuery.staticTexts["Systolic Murmurs"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Mitral Regurgitation"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Aortic Regurgitation"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Mitral Stenosis"].tap()
		element.tap()
		systemsButton.tap()
		tablesQuery.staticTexts["Head, Ear, Eyes, Nose, Throat"].tap()
		examTechniquesButton.tap()
		tablesQuery.staticTexts["Tracheal Alignment"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Otoscopic Exam"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Internal Nasal Exam"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Sinus Palpation/Percussion"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Lymph Node Palpation"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Thyroid Exam Screening"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Thyroid Exam Formal"].tap()
		examTechniqueDetailsNavigationBar.tap()
		systemsButton.tap()
		tablesQuery.staticTexts["Respiratory"].tap()
		examTechniquesButton.tap()
		systemsButton.tap()
		tablesQuery.staticTexts["Neurological"].tap()
		examTechniquesButton.tap()
		tablesQuery.staticTexts["Mental Status Assessment"].tap()
		backButton.tap()
		tablesQuery.staticTexts["CN II-XII Testing"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Muscle Strength Testing"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Finger-Nose-Finger"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Heel-to-Shin"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Rapid Alternating Movements"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Gait"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Romberg"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Sensory Exam: Pain"].tap()
		backButton.tap()
		
		let sensoryExamLightTouchStaticText = tablesQuery.staticTexts["Sensory Exam: Light & Touch"]
		sensoryExamLightTouchStaticText.tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Sensory Exam: Proprioception"].tap()
		backButton.tap()
		sensoryExamLightTouchStaticText.swipeUp()
		tablesQuery.staticTexts["Sensory Exam: Point Localization"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Sensory Exam: Texture Discrimination"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Sensory Exam: Stereognosis"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Sensory Exam: Graphesthesia"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Deep Tendon Reflexe"].tap()
		examTechniqueDetailsNavigationBar.tap()
		
		let plantarToeReflexStaticText = tablesQuery.staticTexts["Plantar Toe Reflex"]
		plantarToeReflexStaticText.tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Plantar Toe Chaddock"].tap()
		examTechniqueDetailsNavigationBar.tap()
		tablesQuery.staticTexts["Plantar Achilles-Toe Reflex"].tap()
		backButton.tap()
		plantarToeReflexStaticText.tap()
		tablesQuery.staticTexts["Plantar Shin-Toe Reflex"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Plantar Calf-Toe Reflex"].tap()
		examTechniqueDetailsNavigationBar.staticTexts["Exam Technique Details"].tap()
		backButton.tap()
		tablesQuery.staticTexts["Plantar Pinprick Toe Reflex"].tap()
		backButton.tap()
		
	}
    
}
