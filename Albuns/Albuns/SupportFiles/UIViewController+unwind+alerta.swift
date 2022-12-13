//
//  UIViewController+unwind.swift
//  Albuns
//
//  Created by Professor on 25/10/21.
//

import UIKit

/// Impementa o método unwind(:UIStoryboardSegue) que permite a
/// função de retorno entre telas
extension UIViewController {
    func alert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
