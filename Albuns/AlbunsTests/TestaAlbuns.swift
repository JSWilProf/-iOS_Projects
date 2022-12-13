//
//  TestaAlbuns.swift
//  AlbunsTests
//
//  Created by Professor on 27/10/21.
//

import XCTest
@testable import Albuns

class TestaAlbuns: XCTestCase {
    let dataBase = DataBaseController.sharedInstance

    override func setUpWithError() throws {
        func criaAlbum(_ nome: String,_ banda: String, _ ano: String, _ estilo: String, _ capa: UIImageView?, _ url: String) throws {
            let album = dataBase.novoAlbum()
            album.nome = nome
            album.banda = banda
            album.ano = ano.numberValue
            album.estilo = estilo
            album.capa = capa?.image?.pngData()
            album.url = url
            try dataBase.salvar()
        }
        let capa = UIImageView(image: UIImage(systemName: "disco_teste"))

        try criaAlbum("Empty Words", "Alix Perez", "2014", "Jungle", capa, "http://www.google.com.br")
        try criaAlbum("Stay Like This", "Maduk", "2021", "Drum’n’bass", capa, "http://www.google.com.br")
    }

    override func tearDownWithError() throws {
        func removeAlbum(_ nome: String) throws {
            if let album = try dataBase.localizar(nome: nome) {
                try dataBase.delete(album)
            }
        }

        do { try removeAlbum("Rise from the Ashe") } catch {}
        do { try removeAlbum("Empty Words") } catch {}
        do { try removeAlbum("Stay Like This") } catch {}
    }

    func testListaAlbuns() throws {
        for album in try dataBase.albuns() {
            print("id: \(String(describing: album.id)) nome: \(String(describing: album.nome))")
        }
    }
    
    func testCriaAlbum() throws {
        let capa = UIImageView(image: UIImage(systemName: "disco_teste")).image?.pngData()
        
        let album = dataBase.novoAlbum()
        album.nome = "Rise from the Ashe"
        album.banda = "The Ghost Inside"
        album.ano = "2016".numberValue
        album.estilo = "Rock"
        album.capa = capa
        album.url = "http://oi.com.br"
        try dataBase.salvar()
        
        let oAlbum = try dataBase.localizar(nome: "Rise from the Ashe")

        XCTAssertTrue(oAlbum != nil, "Álbum não encontrado")
        XCTAssertEqual(album.nome, oAlbum!.nome, "Nomes diferentes")
        XCTAssertEqual(album.capa, oAlbum!.capa, "Capas dos objetos diferentes")
        XCTAssertEqual(capa, oAlbum!.capa, "Capas UIImageView diferentes")
    }
    
    func testLocalizaAlbum() throws {
        let album = try dataBase.localizar(nome: "Stay Like This")
        XCTAssertTrue(album != nil)
    }
    
    func testRemoveAlbum() throws {
        var album = try dataBase.localizar(nome: "Empty Words")

        XCTAssertTrue(album != nil)

        try dataBase.delete(album!)

        album = try dataBase.localizar(nome: "Empty Words")

        XCTAssertTrue(album == nil)
    }
}
