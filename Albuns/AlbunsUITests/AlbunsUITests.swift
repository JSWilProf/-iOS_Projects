//
//  AlbunsUITests.swift
//  AlbunsUITests
//
//  Created by professor on 12/12/22.
//

import XCTest

class AlbunsUITests: XCTestCase {
    override func setUpWithError() throws {
        XCUIDevice.shared.orientation = .portrait
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func logar(_ app: XCUIApplication, _ novaConta: Bool) {
        let loginTextField = app.textFields["login"]
        let loginExists = loginTextField.waitForExistence(timeout: 2)
        XCTAssertTrue(loginExists)
        if novaConta {
            loginTextField.tap()
            loginTextField.typeText("teste1")
        }
        let senhaTextField = app.secureTextFields["senha"]
        senhaTextField.tap()
        senhaTextField.typeText("teste1")
        loginTextField.tap()
        app.staticTexts["Entrar"].tap()
    }
    
    func criarConta(_ app: XCUIApplication) {
        let tablesQuery = app.tables
        let cadLoginTextField = tablesQuery.textFields["cad_login"]
        cadLoginTextField.tap()
        cadLoginTextField.typeText("teste1")
        let cadSenhaTextField = tablesQuery.secureTextFields["cad_senha"]
        cadSenhaTextField.tap()
        cadSenhaTextField.typeText("teste1")
        cadLoginTextField.tap()
        tablesQuery.buttons["Salvar"].tap()
    }
    
    func cadastrarAlbum(_ app: XCUIApplication) {
        let tablesQuery = app.tables
        let nome = tablesQuery.textFields["album_nome"]
        nome.tap()
        nome.typeText("Elysium")
        let banda = tablesQuery.textFields["album_banda"]
        banda.tap()
        banda.typeText("Jo Blankenburg")
        let estilo = tablesQuery.textFields["album_estilo"]
        estilo.tap()
        estilo.typeText("Clássico")
        let ano = tablesQuery.textFields["album_ano"]
        ano.tap()
        ano.typeText("2014")
        let url = tablesQuery.textFields["album_url"]
        url.tap()
        url.typeText("https://youtu.be/BPfzWZsszcw")
        app.navigationBars["Álbum"].buttons["Salvar"].tap()
    }
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
 
        var novaConta = false
        
        let botaoCadastrar = app.staticTexts["Cadastrar"]
        let botaoEntrar = app.staticTexts["Entrar"]
        _ = botaoEntrar.waitForExistence(timeout: 3)
        if botaoCadastrar.exists {
            botaoCadastrar.tap()
            criarConta(app)
            novaConta = true
        }
        
        logar(app, novaConta)
        
        let novo = app.navigationBars["Álbuns"].buttons["Novo"]
        _ = novo.waitForExistence(timeout: 1)
        let alerta = app.alerts["Sem Álbuns cadastrados"]
        if alerta.exists {
            alerta.scrollViews.otherElements.buttons["Fechar"].tap()
            novo.tap()
            cadastrarAlbum(app)
        } //else {
            let albunsNavigationBar = app.navigationBars["Álbuns"]
            albunsNavigationBar.buttons["Editar"].tap()
            let tablesQuery = app.tables
            tablesQuery.buttons["Delete Elysium, Jo Blankenburg"].tap()
            tablesQuery.buttons["Delete"].tap()
            app.otherElements["Atenção"].scrollViews.otherElements.buttons["Confirma"].tap()
    }
}
