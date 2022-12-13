//
//  String+Int64.swift  
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//  

import Foundation
import UIKit

extension String {
    var numberValue: Int64 {
        if let value = Int(self) {
            return Int64(value)
        }
        return -1
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
