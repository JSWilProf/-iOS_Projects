//
//  CadastroViewController.swift
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//

import UIKit

class CadastroViewController: UITableViewController {
    /// Declaração das referências aos componentes da tela
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var botaoSalvar: UIBarButtonItem!
    
    /// Declaração das variáveis utilziadas globalmente nesta classe
    private var hasLogin = false
    private var hasSenha = false
    
    /// Inicializa o View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confiuraCampos()
    }
    
    /// Método utilizado para tratar o retorno para a tela anterior com a solicitação
    /// para armazenar a conta e senha cadastradas.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let botao = sender as? UIBarButtonItem else { return }
        if botao.title == "Salvar" {
            let store = PListController.sharedInstance
            do {
                try store.setLogin(Login(login: login.text!, senha: senha.text!.toBase64(), faceId: false))
            } catch {
                alert("Falha interna", message: "Houve falha ao salvar a conta")
            }
        }
    }
}

/// Extensão que implementa as funcionalidades para controlar os
/// Text Fields onde são informados a conta e senha .
extension CadastroViewController: UITextFieldDelegate {
    /// Atribui a classe corrente como responsável por gerir as interações com os text fields
    func confiuraCampos() {
        login.delegate = self
        senha.delegate = self
    }
    
    /// Verifica as condições para habilitar o botão Salvar
    private func checkState(_ textField: UITextField) {
        switch textField {
            case login:
                hasLogin = login.text!.count > 0
            case senha:
                hasSenha = senha.text!.count > 0
            default:
                break
        }
        
        botaoSalvar.isEnabled = hasLogin && hasSenha
    }
    
    /// Detecta a edição em um text field para executa a função
    /// checkState que verificar se o botão salvar pode ser habilitado
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkState(textField)
    }
    
    /// Detecta a edição em um text field para executa a função checkState que verificar se o botão salvar pode ser habilitado
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkState(textField)
        return true
    }
    
    /// Transfere o foco de edição nos text fields assim que for solicitado a saída da edição de qualquer text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case login:
                senha.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        return true
    }
}
