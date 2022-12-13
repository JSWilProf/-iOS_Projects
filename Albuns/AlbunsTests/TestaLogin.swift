//
//  TestaLogin.swift
//  AlbunsTests
//
//  Created by Professor on 28/10/21.
//

import UIKit
import XCTest
@testable import Albuns

class TestaLogin: XCTestCase {
    let store = PlistController.sharedInstance
    
    override func setUpWithError() throws {
        try store.setLogin(Login(login: "beltrano", senha: "i2Ea5p".toBase64(), faceId: false))
    }

    override func tearDownWithError() throws {
        try store.removeLogin()
    }
    
    func testLeituraDoLogin() throws {
        let login = store.getLogin()
        let storedLogin = login?.login
        let storedSenha = login?.senha
        let storedFaceId = login?.faceId
        
        XCTAssertEqual("beltrano", storedLogin!, "Login inválido")
        XCTAssertEqual("i2Ea5p", storedSenha!.fromBase64(), "Senha inválida")
        XCTAssertEqual(false, storedFaceId!, "FaceID inválido")
    }
    
    func testSalvarLogin() throws {
        try store.setLogin(Login(login: "teste1", senha: "teste2".toBase64(), faceId: true))
        
        let login = store.getLogin()
        let storedLogin = login?.login
        let storedSenha = login?.senha
        let storedFaceId = login?.faceId

        XCTAssertEqual("teste1", storedLogin!, "Login inválido")
        XCTAssertEqual("teste2", storedSenha!.fromBase64(), "Senha inválida")
        XCTAssertEqual(true, storedFaceId!, "FaceID inválido")
    }
}
