//
//  w1867464_CW_WeatherAPPUITestsLaunchTests.swift
//  w1867464-CW-WeatherAPPUITests
//
//  Created by Sithum Raveesha on 2024-12-11.
//

import XCTest

final class w1867464_CW_WeatherAPPUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
