//
//  GravaPlist.swift
//  Albuns
//
//  Created by penawjs on 28/10/21.
//

import Foundation

class PlistController: NSObject {
    static let sharedInstance = PlistController()
  //  fileprivate var properties: NSMutableDictionary!
    
    fileprivate override init() {
        super.init()
    }
    
    private lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("login.plist")
    }()

    func getLogin() -> Login? {
        if  let file = FileManager.default.contents(atPath: self.applicationDocumentsDirectory.path),
            let login = try? PropertyListDecoder().decode(Login.self, from: file) {
            return login
        } else {
            return nil
        }
    }
    
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
    
    func removeLogin() throws {
        do {
            try FileManager.default.removeItem(atPath: self.applicationDocumentsDirectory.path)
        } catch {
            print(error)
            throw DBError.falhaEmApagarDados
        }
    }
}

struct Login: Codable {
    var login: String
    var senha: String
    var faceId: Bool
}

