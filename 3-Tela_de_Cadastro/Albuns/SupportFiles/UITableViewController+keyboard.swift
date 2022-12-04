//
//  UITableViewController+keyboard.swift
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//

import Foundation
import UIKit

/// Extensão sobre a classe UITableViewController para permitir
/// o controle do teclado virtual no dispositivo móvel
extension UITableViewController {
    /// Registra junto ao gerenciador do teclado virtual
    /// para receber eventos gerados no surgimento ou ocultamento deste.
    func registraKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Observa por eventos de surgimento do teclado virtual
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + tableView.rowHeight, right: 0)
        }
    }
    
    /// Observa por eventos de ocultamento do teclado virtual
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
}
