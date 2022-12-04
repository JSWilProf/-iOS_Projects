//
//  AlbumDetalheViewController.swift  
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//  

import Foundation
import UIKit

class AlbumDetalheViewController: UITableViewController {
    /// Referência utilizada para edição de um Álbum
    private var album: Album?
    /// Referência para o acesso ao Objeto que receberá o evento de edição do álbum
    private var modelDelegate: AlbumModelChangedDelegate?
    /// Declaração das variáveis utilziadas globalmente nesta classe
    private var atualizaFoto = false
    
    /// Declaração das referências aos componentes da tela
    @IBOutlet weak var aCapa: UIImageView!
    @IBOutlet weak var oAlbum: UITextField!
    @IBOutlet weak var aBanda: UITextField!
    @IBOutlet weak var oEstilo: UITextField!
    @IBOutlet weak var oAno: UITextField!
    @IBOutlet weak var oVideo: UITextField!
    @IBOutlet weak var abrirVideo: UIButton!
 
    /// Inicializa o View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registraKeyboard()
        confiuraCampos()
    }
    
    /// Método que recebe o evento de inicialização da Tela de Cadastro
    /// verifica se é para editar um álbum existente ou um novo álbum
    override func viewWillAppear(_ animated: Bool) {
        if let album = album {
            if let cadaData = album.capa, !atualizaFoto {
                aCapa.image = UIImage(data: cadaData)
            }
            oAlbum.text = album.nome
            aBanda.text = album.banda
            oEstilo.text = album.estilo
            oAno.text = album.ano.description
            if let url = album.url {
                oVideo.text = url
            }
        }
    }

    /// Método utilizado para a configuração desta classe
    func configure(with album: Album?, delegate: AlbumModelChangedDelegate) {
        self.album = album
        self.modelDelegate = delegate
    }
    
    /// Método utilizado para salvar os dados do Álbum editado no banco de dados
    /// interno do dispositivo móvel
    @IBAction func salvar(_ sender: Any) {
        do {
            let databaseController = DataBaseController.sharedInstance
            if let velhoAlbum = album {
                velhoAlbum.nome = oAlbum.text!
                velhoAlbum.banda = aBanda.text!
                velhoAlbum.ano = oAno.text!.numberValue
                velhoAlbum.estilo = oEstilo.text!
                velhoAlbum.capa = aCapa.image?.pngData()
                velhoAlbum.url = oVideo.text!
            } else {
                let novoAlbum = databaseController.novoAlbum()
                novoAlbum.nome = oAlbum.text!
                novoAlbum.banda = aBanda.text!
                novoAlbum.ano = oAno.text!.numberValue
                novoAlbum.estilo = oEstilo.text!
                novoAlbum.capa = aCapa.image?.pngData()
                novoAlbum.url = oVideo.text!
            }
            try databaseController.salvar()
            modelDelegate?.albumModelChanged()
            _ = navigationController?.popToRootViewController(animated: true)
        } catch {
            alert("Falha ao gravar", message: "O Álbum não pode ser gravado")
        }
    }
}

/// Extensão utilizada para controlar os TextFields (Campos de edição) e sua navegação
extension AlbumDetalheViewController: UITextFieldDelegate {
    /// Ativa o gerenciamento de todos os campos da tela
    func confiuraCampos() {
        oAlbum.delegate = self
        aBanda.delegate = self
        oEstilo.delegate = self
        oAno.delegate = self
        oVideo.delegate = self
    }
        
    /// Método que controla a sequencia de navegação dos campos na tela
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case oAlbum:
                aBanda.becomeFirstResponder()
            case aBanda:
                oEstilo.becomeFirstResponder()
            case oEstilo:
                oAno.becomeFirstResponder()
            case oAno:
                oVideo.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        return true
    }
}

/// Extensão utilizada para configurar o TableViewController
extension AlbumDetalheViewController {
    /// Configura o cabeçalho do Table View removendo o espaço acima dos itens da lista
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    /// Configura o rodapé do Table View removendo o espaço abaixo dos itens da lista
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
