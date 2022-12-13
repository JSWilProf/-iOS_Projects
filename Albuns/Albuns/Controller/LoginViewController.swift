//
//  ViewController.swift
//  Albuns
//
//  Created by Professor on 22/10/21.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var botaoEntrar: UIButton!
    @IBOutlet weak var botaoCadastrar: UIButton!
    @IBOutlet weak var faceIdSwitch: UISwitch!
    
    private let store = PlistController.sharedInstance
    private var hasLogin = false
    private var hasSenha = false
    private var storedLogin: Login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        carregaDados()
        
        confiuraCampos()
    }
    
    private func carregaDados() {
        storedLogin = store.getLogin()
    }
    
    private func sucesso() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "telaInicial") as! UINavigationController
        view.window?.rootViewController = nextViewController
        view.window?.makeKeyAndVisible()
    }
    
    private func autenticaComSenha() {
        if login.text! == storedLogin?.login &&
           senha.text!.toBase64() == storedLogin?.senha {
            sucesso()
        } else {
            alert("Falha na Autenticação", message: "A conta e/ou senha não exite(m)")
        }
    }
    
    private func autenticaComFacedID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Faça o Login"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async { [self] in
                    if success {
                        self?.sucesso()
                    } else {
                        self?.alert("Falha na Autenticação", message: "Tente utilizar a senha ao invés")
                    }
                }
            }
        } else {
            autenticaComSenha()
        }
    }
    
    @IBAction func entrar(_ sender: Any) {
        carregaDados()
        if faceIdSwitch.isOn {
            autenticaComFacedID()
        } else {
            autenticaComSenha()
        }
    }

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
}

extension LoginViewController: UITextFieldDelegate {
    func confiuraCampos() {
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
        
        /// Não tem Login cadastrato? Habilite o botão cadastrar
        if temLogin && temSenha {
            botaoCadastrar.isHidden = true
        }

        /// Já tem login cadastrado? Carregue o login
        if let oLogin = storedLogin?.login {
            login.text = oLogin
        }
        
        /// Habilita o FaceID?
        faceIdSwitch.isEnabled = temLogin && temSenha
        if let oFaceId = storedLogin?.faceId {
            faceIdSwitch.isOn = oFaceId
            
            if temSenha && faceIdSwitch.isOn {
                senha.isHidden = true
                botaoEntrar.isEnabled = true
            }
        }
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
        case login:
            senha.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    /// Esta função somente é necessária para que a tela de cadastro retorne para a tela de login
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
}
