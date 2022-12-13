//
//  CadastroViewcontroller.swift
//  Albuns
//
//  Created by Professor on 23/10/21.
//


import UIKit

class CadastroViewController: UITableViewController {
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var botaoSalvar: UIBarButtonItem!
    
    private var hasLogin = false
    private var hasSenha = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confiuraCampos()
        
        registraKeyboard()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let botao = sender as? UIBarButtonItem else { return }
        if botao.title == "Salvar" {
            let store = PlistController.sharedInstance
            do {
                try store.setLogin(Login(login: login.text!, senha: senha.text!.toBase64(), faceId: false))
            } catch {
                alert("Falha interna", message: "Houve falha ao salvar a conta")
            }
        }
    }
}

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
    
    /// Detecta a edição em um text field para executa a função checkState que verificar se o botão salvar pode ser habilitado
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
