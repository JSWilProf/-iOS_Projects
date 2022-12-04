//
//  AlbumViewController.swift  
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//  

import Foundation
import UIKit

/// Protocolo que define o padrão de comunicação entre as
/// Classes que controlam o Detalhe de Álbum e Lista de Álbuns
protocol AlbumModelChangedDelegate {
    /// Definição de método com o intúito de permitir informar
    /// o evento de alteração de dados de um determinado
    /// Álbum que foi editado na Tela de Detalhe
    func albumModelChanged()
}

class AlbumViewController: UITableViewController, AlbumModelChangedDelegate {
    /// Identificação da ligação para Tela de Detalhe utilizada em sua navegação
    static let detalheIdentifier = "ShowAlbumDetalheSegue"
    /// Referência ao Gerenciador de dados
    let databaseController = DataBaseController.sharedInstance
    /// Lista de álbuns a ser apresentada na tela
    var albuns: [Album]!
    /// Definição possíveis estados para controle da apresentação da lista de álbuns
    enum Estado {
        case normal
        case vazio
        case erro
    }
    var estado = Estado.vazio
    
    //#MARK: Dados gerados para validação da aplicação
    // - - - - - - - - - - - - - - - - - - - - - - - -

    /// Inicializa o View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try setUpInicial()
        } catch {}
    }
    
    /// Método para criação de Objetos para validação da aplicação
    private func criaAlbum(_ nome: String,_ banda: String, _ estilo: String, _ ano: Int64, _ capa: UIImageView?, _ url: String) throws -> Album? {
        let album = databaseController.novoAlbum()
        album.nome = nome
        album.banda = banda
        album.estilo = estilo
        album.ano = ano
        album.capa = capa?.image?.pngData()
        album.url = url
        try databaseController.salvar()
        
        return album
    }

    /// Método que cria os álbuns para validação da aplicação
    private func setUpInicial() throws {
        try databaseController.albuns()?.forEach { album in
            try databaseController.delete(album)
        }
        
        let capa = UIImageView(image: UIImage(systemName: "detalhe"))
        
        _ = try criaAlbum("Empty Words", "Alix Perez", "Jungle", 2021, capa, "https://www.youtube.com/watch?v=FDlpZM5KyMs")
        _ = try criaAlbum("Simplicity", "AudioSketch", "Dance", 2021, capa, "https://www.youtube.com/watch?v=dOfwho92xcw")
    }
    
    // - - - - - - - - - - - - - - - - - - - - - - - -

    /// Método que recebe o evento de inicialização da Tela principal
    /// e consulta a lista de álbuns para apresentar na lista da tela
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            albuns = try databaseController.albuns()
            
            if albuns != nil {
                estado = .normal
                self.navigationItem.rightBarButtonItem = self.editButtonItem
                editButtonItem.title = "Editar"
            }
        } catch {
            estado = .erro
        }
    }
    
    /// Método que apresenta o texto do botão no tompo superior direito da tela
    /// do aplicativo
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.editButtonItem.title = editing ? "Concluir" : "Editar"
    }
    
    /// Método que revebe o evento de finalização da apresentação da tela principal
    /// e dependendo do estado da carga da lista de álbuns, apresenta mensagem
    /// correspondente
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch estado {
            case .vazio:
                alert("Sem Álbuns cadastrados", message: "Não existem Álbuns cadastrados até o momento")
            case .erro:
                alert("Falha ao acessar os dados", message: "Os dados dos Álbuns não puderam ser recuperados")
            default:
                break
        }
    }

    /// Método correspondente ao protocolo que recebe o evento de
    /// alterações em dados de Álbum editado na tela de Detalhe
    /// e na ocorrência deste evento recarrega a lista dos álbuns
    /// na tela principal
    func albumModelChanged() {
        do {
            albuns = try databaseController.albuns()
            tableView.reloadData()
        } catch {
            alert("Falha ao acesso aos dados", message: "Os dados dos Álbuns não puderam ser recuperados")
        }
    }
}

/// Extensão que implementa as funcionalidades para controlar os
/// TableView onde são apresentadas a lista dos álbuns.
extension AlbumViewController {
    /// Identificação da Célula que apresenta dados dos itens na lista principal
    static let identifier = "AlbumListCell"
    
    /// Método que informa a quantidade de elementos na lista de álbuns
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albuns != nil ? albuns.count : 0
    }
    
    /// Método que constroi e carrega cada célula apresentada na lista de álbuns
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell( withIdentifier: Self.identifier, for: indexPath) as? AlbumListCell else {
            fatalError("Erro ao localizar o \(Self.identifier)")
        }
        
        let album = albuns[indexPath.row]
        cell.configure(album: album.nome!, banda: album.banda!, capa: album.capa)
        return cell
    }
    
    /// Método que trata da exclusão de um item na lista de álbuns
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // cria um alerta
            let alert = UIAlertController(title: "Atenção", message: "Confirma a exclusão do Álbum?", preferredStyle: .actionSheet)
            // adiciona os botões das ações
            alert.addAction(UIAlertAction(title: "Confirma", style: .destructive, handler: { [self] (action: UIAlertAction) -> Void in
                do {
                    try databaseController.delete(albuns[indexPath.row])
                    albuns = try databaseController.albuns()
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.endUpdates()
                } catch {
                    self.alert("Fala ao acesso aos dados", message: "A ação não pode ser executada por problemas no armazenamento dos dados")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancela", style: .cancel, handler:  nil))
            
            // apresenta o alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}
