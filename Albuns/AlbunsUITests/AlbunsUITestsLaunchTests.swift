//
//  AlbunsUITestsLaunchTests.swift
//  AlbunsUITests
//
//  Created by professor on 12/12/22.
//

import XCTest

class AlbunsUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app
//        let botaoEntrar = app.staticTexts["Entrar"]
//        botaoEntrar.tap()
//        let alerta = app.alerts["Falha na Autenticação"]
//        if alerta.exists {
//            alerta.scrollViews.otherElements.buttons["Fechar"].tap()
//        }

        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
