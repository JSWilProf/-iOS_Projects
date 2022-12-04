//
//  UIViewController+alert.swift
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//

import Foundation
import UIKit

/// Extensão sobre a classe UIViewController
extension UIViewController {
    /// Acrescenta a fulcionalidade de criação de diálogo de alerta
    func alert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
