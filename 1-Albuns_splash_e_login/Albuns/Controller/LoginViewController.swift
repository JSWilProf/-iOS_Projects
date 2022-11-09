//
//  LoginViewController.swift  
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//  

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    /// Declaração das referências aos componentes da tela
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var botaoEntrar: UIButton!
    @IBOutlet weak var botaoCadastrar: UIButton!
    @IBOutlet weak var faceIDSwitch: UISwitch!
    
    /// Declaração das variáveis utilziadas globalmente nesta classe
    private let store = PListController.sharedInstance
    private var hasLogin = false
    private var hasSenha = false
    private var storedLogin: Login!
    
    /// Inicializa o View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carregaDados()
        configuraCampos()
    }
    
    /// Carrega o Login e a Senha armazenados previamente
    private func carregaDados() {
        storedLogin = store.getLogin()
    }

    /// Chama o mecanismo de autenticação
    @IBAction func entrar(_ sender: Any) {
        carregaDados()
        if faceIDSwitch.isOn {
            autenticaComFaceID()
        } else {
            autenticaComSenha()
        }
    }

    /// Autentica utilizando o login e senha informados
    private func autenticaComSenha() {
        if login.text! == storedLogin?.login &&
           senha.text!.toBase64() == storedLogin?.senha {
            sucesso()
        } else {
            alert("Falha na Autenticação",
                  message: "A conta e/ou senha não existe(m)")
        }
    }

    /// Autentica com biometria do FaceID/TouchID
    private func autenticaComFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Faça o Login"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async { [self] in
                    if success {
                        self?.sucesso()
                    } else {
                        self?.alert("Falha na Autenticação", message: "Tente utilizar a senha ao invéz")
                    }
                }
            }
        } else {
            autenticaComSenha()
        }
    }
    
    /// Trata o evento de troca do switch do FaceID/TouchID
    @IBAction func trocaFaceID(_ sender: Any) {
        if let faceId = sender as? UISwitch {
            do {
                storedLogin.faceId = faceId.isOn
                try store.setLogin(storedLogin)
                botaoEntrar.isEnabled = faceId.isOn
                senha.isHidden = faceId.isOn
            } catch {
                alert("Falha", message: "Falha na configuração do Face/Touch ID")
            }
        }
    }

    
    /// Houve sucesso na autenticação, carregue a tela inicial
    private func sucesso() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "telaInicial") as! UINavigationController
        view.window?.rootViewController = nextViewController
        view.window?.makeKeyAndVisible()
    }
}

/// Extensão que implementa as funcionalidades para controlar os
/// Text Fields onde são informados a conta, a senha e opção de Face ID.
extension LoginViewController: UITextFieldDelegate {
    
    /// Configura os campos da tela
    func configuraCampos() {
        var temLogin = false
        var temSenha = false
        
        /// Já tem login cadastrado?
        if let login = storedLogin?.login {
            temLogin = !login.isEmpty
        }
        
        /// Já tem senha cadastrada?
        if let senha = storedLogin?.senha {
            temSenha = !senha.isEmpty
        }
        
        /// Delegue o controle dos campos para esta rotina
        login.delegate = self
        senha.delegate = self
        
        /// Não tem Login cadastrado? Habilite o botão cadastrar
        if temLogin && temSenha {
            botaoCadastrar.isHidden = true
        }
        
        /// Já tem login cadastrado? Carregue o login
        if let oLogin = storedLogin?.login {
            login.text = oLogin
        }
        
        /// Habilita o FaceID?
        faceIDSwitch.isEnabled = temLogin && temSenha
        if let oFaceId = storedLogin?.faceId {
            faceIDSwitch.isOn = oFaceId
            
            if temSenha && faceIDSwitch.isOn {
                senha.isHidden = true
                botaoEntrar.isEnabled = true
            }
        }
    }
    
    /// Esta função somente é necessária para que a tela de cadastro
    /// retorne para a tela de login
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }

    /// Pode fazer o login? Habilita o botão Entrar?
    func textFieldDidEndEditing(_ textField: UITextField) {
        hasLogin = login.text!.count > 0
        hasSenha = senha.text!.count > 0
        
        botaoEntrar.isEnabled = hasLogin && hasSenha
    }
    
    /// Passa para o próximo campo com o Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case login: senha.becomeFirstResponder()
            default: textField.resignFirstResponder()
        }
        return true
    }
}
