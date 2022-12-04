//
//  String+Int64.swift  
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//  

import Foundation
import UIKit

/// Extensão sobre a classe String
extension String {
    /// Acrescenta conversão de String para Inteiro
    var numberValue: Int64 {
        if let value = Int(self) {
            return Int64(value)
        }
        return -1
    }
    
    /// BASE64 é um formato de codificação de textos muito utilizado
    /// para formatar anexos em e-mail, também possibilitando o
    /// armazenamento de imagems como String.
    
    /// Acrescenta conversão de BASE64 para String
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    /// Acrescenta conversão de String para BASE64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
