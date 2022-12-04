//
//  PListController.swift  
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//  

import Foundation

/// Estrutura que define os dados para o cadastro
/// do usuário que usa a aplicação
struct Login: Codable {
    var login: String
    var senha: String
    var faceId: Bool
}

/// Classe que faz o gerenciamento dos dados da
/// conta do usuário
class PListController: NSObject {
    /// Referência que permite o acesso a este objeto
    /// por toda a aplicação
    static let sharedInstance = PListController()
    
    /// Método declarado com "fileprivate" para
    /// impedir a criação de objetos desta classe
    fileprivate override init() {
        super.init()
    }
    
    /// Referência do arquivo que armazena a conta do
    /// usuário. A declaração "lazy" permite que a inicialização
    /// desta referência ocorra somente quando for utilizada
    private lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("login.plist")
    }()
    
    /// Método que consulta os dados cadastrados do usuário
    func getLogin() -> Login? {
        if let file = FileManager.default.contents(atPath: self.applicationDocumentsDirectory.path),
           let login = try? PropertyListDecoder().decode(Login.self, from: file) {
            return login
        } else {
            return nil
        }
    }
    
    /// Método que grava os dados do usuário
    func setLogin(_ login: Login) throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        
        do {
            let data = try encoder.encode(login)
            try data.write(to: self.applicationDocumentsDirectory)
        } catch {
            print(error)
            throw DBError.falhaAoSalvarDados
        }
    }
}
